#!/bin/bash

# ============================================
# Inventory Management System - Startup Script
# ============================================
# This script initializes and starts all components:
# 1. MongoDB database
# 2. Node.js backend API (port 8000)
# 3. Java Swing Dashboard GUI
# ============================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Inventory Management System${NC}"
echo -e "${BLUE}  Starting All Services${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a port is in use
check_port() {
    lsof -i :$1 >/dev/null 2>&1
}

# Function to wait for a service to be ready
wait_for_service() {
    local url=$1
    local max_attempts=30
    local attempt=0
    
    echo -e "${YELLOW}Waiting for service at $url...${NC}"
    while [ $attempt -lt $max_attempts ]; do
        if curl -s "$url" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ Service is ready!${NC}"
            return 0
        fi
        attempt=$((attempt + 1))
        sleep 1
    done
    echo -e "${RED}✗ Service failed to start${NC}"
    return 1
}

# ============================================
# 1. Check Prerequisites
# ============================================
echo -e "${BLUE}[1/5] Checking prerequisites...${NC}"

# Check MongoDB
if ! command_exists mongod; then
    echo -e "${YELLOW}⚠ MongoDB not found in PATH. Trying Homebrew installation...${NC}"
    if command_exists brew; then
        if brew services list | grep -q mongodb-community; then
            echo -e "${GREEN}✓ MongoDB service found via Homebrew${NC}"
        else
            echo -e "${RED}✗ MongoDB not installed. Please install MongoDB first.${NC}"
            echo "   Run: brew install mongodb-community@7.0"
            exit 1
        fi
    else
        echo -e "${RED}✗ MongoDB not found and Homebrew not available${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ MongoDB found${NC}"
fi

# Check Node.js
if ! command_exists node; then
    echo -e "${RED}✗ Node.js not found. Please install Node.js first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js found ($(node --version))${NC}"

# Check Java
if ! command_exists java; then
    # Try to set Java path if available
    if [ -d "/opt/homebrew/opt/openjdk@17" ]; then
        export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
        export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
        echo -e "${YELLOW}⚠ Java not in PATH, using Homebrew OpenJDK 17${NC}"
    else
        echo -e "${RED}✗ Java not found. Please install Java 17 first.${NC}"
        echo "   Run: brew install openjdk@17"
        exit 1
    fi
fi
if command_exists java; then
    echo -e "${GREEN}✓ Java found ($(java -version 2>&1 | head -n1))${NC}"
else
    echo -e "${RED}✗ Java still not available after path setup${NC}"
    exit 1
fi

# Check Maven
if ! command_exists mvn; then
    echo -e "${YELLOW}⚠ Maven not found. Will compile manually if needed.${NC}"
else
    echo -e "${GREEN}✓ Maven found${NC}"
fi

echo ""

# ============================================
# 2. Start MongoDB
# ============================================
echo -e "${BLUE}[2/5] Starting MongoDB...${NC}"

if command_exists brew; then
    # Try Homebrew service
    if brew services list | grep -q mongodb-community; then
        if ! brew services list | grep mongodb-community | grep -q started; then
            echo -e "${YELLOW}Starting MongoDB via Homebrew...${NC}"
            brew services start mongodb-community@7.0
            sleep 2
        else
            echo -e "${GREEN}✓ MongoDB already running${NC}"
        fi
    else
        # Try direct mongod
        if ! pgrep -x mongod > /dev/null; then
            echo -e "${YELLOW}Starting MongoDB daemon...${NC}"
            mongod --dbpath /usr/local/var/mongodb --fork --logpath /usr/local/var/log/mongodb/mongo.log 2>/dev/null || \
            mongod --dbpath ~/data/db --fork --logpath ~/data/log/mongo.log 2>/dev/null || \
            echo -e "${YELLOW}⚠ Could not auto-start MongoDB. Please start manually.${NC}"
        else
            echo -e "${GREEN}✓ MongoDB already running${NC}"
        fi
    fi
else
    echo -e "${YELLOW}⚠ Please ensure MongoDB is running manually${NC}"
fi

# Wait for MongoDB to be ready
sleep 2
if nc -z localhost 27017 2>/dev/null; then
    echo -e "${GREEN}✓ MongoDB is ready${NC}"
    
    # Verify database connection
    echo -e "${YELLOW}Verifying database connection...${NC}"
    if command_exists mongosh; then
        DB_CHECK=$(mongosh inventory_db --quiet --eval "db.getName()" 2>/dev/null)
        if [ "$DB_CHECK" = "inventory_db" ]; then
            PRODUCT_COUNT=$(mongosh inventory_db --quiet --eval "db.products.countDocuments()" 2>/dev/null)
            echo -e "${GREEN}✓ Connected to database: inventory_db${NC}"
            echo -e "${GREEN}✓ Products in database: ${PRODUCT_COUNT}${NC}"
        else
            echo -e "${YELLOW}⚠ Could not verify database connection${NC}"
        fi
    fi
else
    echo -e "${YELLOW}⚠ MongoDB may not be ready yet. Continuing...${NC}"
fi

echo ""

# ============================================
# 3. Start Backend API (Node.js)
# ============================================
echo -e "${BLUE}[3/5] Starting Backend API Server...${NC}"

# Check if port 8000 is already in use
if check_port 8000; then
    echo -e "${YELLOW}⚠ Port 8000 is already in use. Checking if it's our backend...${NC}"
    if curl -s http://localhost:8000/api/health >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Backend API already running on port 8000${NC}"
        BACKEND_RUNNING=true
    else
        echo -e "${RED}✗ Port 8000 is in use by another application${NC}"
        echo -e "${YELLOW}Please stop the application using port 8000 and try again${NC}"
        exit 1
    fi
else
    BACKEND_RUNNING=false
fi

if [ "$BACKEND_RUNNING" = false ]; then
    cd "$SCRIPT_DIR/backend"
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}Installing backend dependencies...${NC}"
        npm install
    fi
    
    # Start backend in background with explicit database connection
    echo -e "${YELLOW}Starting backend server on port 8000...${NC}"
    echo -e "${YELLOW}Connecting to database: inventory_db${NC}"
    PORT=8000 MONGODB_URI="mongodb://localhost:27017/inventory_db" node server.js > ../backend.log 2>&1 &
    BACKEND_PID=$!
    echo $BACKEND_PID > ../backend.pid
    
    # Wait for backend to be ready
    if wait_for_service "http://localhost:8000/api/health"; then
        echo -e "${GREEN}✓ Backend API started successfully (PID: $BACKEND_PID)${NC}"
    else
        echo -e "${RED}✗ Backend API failed to start${NC}"
        echo -e "${YELLOW}Check backend.log for errors${NC}"
        exit 1
    fi
fi

echo ""

# ============================================
# 4. Build Java GUI (if needed)
# ============================================
echo -e "${BLUE}[4/5] Preparing Java Dashboard GUI...${NC}"

cd "$SCRIPT_DIR/java-gui"

# Check if JAR exists and is recent
JAR_FILE="target/inventory-management-gui-1.0.0.jar"
if [ -f "$JAR_FILE" ]; then
    JAR_AGE=$(($(date +%s) - $(stat -f %m "$JAR_FILE" 2>/dev/null || stat -c %Y "$JAR_FILE" 2>/dev/null)))
    if [ $JAR_AGE -lt 3600 ]; then  # Less than 1 hour old
        echo -e "${GREEN}✓ JAR file exists and is recent${NC}"
    else
        echo -e "${YELLOW}JAR file is old. Rebuilding...${NC}"
        if command_exists mvn; then
            mvn -q clean package -DskipTests
            echo -e "${GREEN}✓ JAR rebuilt successfully${NC}"
        else
            echo -e "${YELLOW}⚠ Maven not found. Using existing JAR${NC}"
        fi
    fi
else
    echo -e "${YELLOW}JAR file not found. Building...${NC}"
    if command_exists mvn; then
        mvn -q clean package -DskipTests
        echo -e "${GREEN}✓ JAR built successfully${NC}"
    else
        echo -e "${RED}✗ Maven not found and JAR doesn't exist${NC}"
        echo -e "${YELLOW}Please build the JAR manually: cd java-gui && mvn package${NC}"
        exit 1
    fi
fi

echo ""

# ============================================
# 5. Start Java Dashboard GUI
# ============================================
echo -e "${BLUE}[5/5] Starting Java Dashboard GUI...${NC}"

# Ensure Java is in PATH
if [ -d "/opt/homebrew/opt/openjdk@17" ]; then
    export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
    export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
fi

# Start GUI
if [ -f "$JAR_FILE" ]; then
    echo -e "${YELLOW}Launching dashboard...${NC}"
    java -jar "$JAR_FILE" > ../dashboard.log 2>&1 &
    GUI_PID=$!
    echo $GUI_PID > ../dashboard.pid
    echo -e "${GREEN}✓ Dashboard GUI started (PID: $GUI_PID)${NC}"
    echo -e "${GREEN}✓ Dashboard window should open shortly${NC}"
else
    echo -e "${RED}✗ JAR file not found: $JAR_FILE${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✅ All Services Started Successfully!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "📊 ${GREEN}Dashboard GUI${NC} is running"
echo -e "🔧 ${GREEN}Backend API${NC} is running on http://localhost:8000"
echo -e "💾 ${GREEN}MongoDB${NC} is running on localhost:27017"
echo -e "🗄️  ${GREEN}Database${NC}: inventory_db"
echo ""
echo -e "📝 Process IDs saved to:"
echo -e "   - backend.pid (Backend server)"
echo -e "   - dashboard.pid (GUI application)"
echo ""
echo -e "📋 Log files:"
echo -e "   - backend.log"
echo -e "   - dashboard.log"
echo ""
if command_exists mongosh; then
    PRODUCT_COUNT=$(mongosh inventory_db --quiet --eval "db.products.countDocuments()" 2>/dev/null || echo "?")
    echo -e "📦 Products in database: ${PRODUCT_COUNT}"
fi
echo ""
echo -e "💡 ${YELLOW}To import CSV data, run:${NC}"
echo -e "   ${YELLOW}cd backend && npm run import-csv${NC}"
echo ""
echo -e "🛑 To stop all services, run:"
echo -e "   ${YELLOW}./stop-all.sh${NC}"
echo ""
echo -e "${GREEN}Enjoy your Inventory Management System! 🚀${NC}"

