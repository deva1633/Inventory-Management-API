#!/bin/bash

# ============================================
# Inventory Management System - Stop Script
# ============================================
# This script stops all running services:
# 1. Java Dashboard GUI
# 2. Node.js Backend API
# 3. Optionally MongoDB (if started by script)
# ============================================

set -e

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
echo -e "${BLUE}  Stopping All Services${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to kill process by PID file
kill_by_pid_file() {
    local pid_file=$1
    local service_name=$2
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" > /dev/null 2>&1; then
            echo -e "${YELLOW}Stopping $service_name (PID: $pid)...${NC}"
            kill "$pid" 2>/dev/null || true
            sleep 1
            # Force kill if still running
            if ps -p "$pid" > /dev/null 2>&1; then
                kill -9 "$pid" 2>/dev/null || true
            fi
            rm -f "$pid_file"
            echo -e "${GREEN}✓ $service_name stopped${NC}"
        else
            echo -e "${YELLOW}⚠ $service_name was not running${NC}"
            rm -f "$pid_file"
        fi
    else
        echo -e "${YELLOW}⚠ No PID file found for $service_name${NC}"
    fi
}

# Stop Dashboard GUI
echo -e "${BLUE}[1/3] Stopping Dashboard GUI...${NC}"
kill_by_pid_file "dashboard.pid" "Dashboard GUI"

# Also try to kill any remaining Java processes for our app
pkill -f "inventory-management-gui" 2>/dev/null && echo -e "${GREEN}✓ Additional Java processes terminated${NC}" || true

echo ""

# Stop Backend API
echo -e "${BLUE}[2/3] Stopping Backend API...${NC}"
kill_by_pid_file "backend.pid" "Backend API"

# Also try to kill by port
if lsof -ti:8000 > /dev/null 2>&1; then
    echo -e "${YELLOW}Killing process on port 8000...${NC}"
    lsof -ti:8000 | xargs kill -9 2>/dev/null || true
    echo -e "${GREEN}✓ Port 8000 cleared${NC}"
fi

echo ""

# Stop MongoDB (optional - commented out by default)
echo -e "${BLUE}[3/3] MongoDB Status...${NC}"
echo -e "${YELLOW}⚠ MongoDB is not stopped by default${NC}"
echo -e "${YELLOW}   To stop MongoDB, run: brew services stop mongodb-community@7.0${NC}"
echo -e "${YELLOW}   Or: mongod --shutdown${NC}"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✅ All Services Stopped!${NC}"
echo -e "${BLUE}========================================${NC}"

