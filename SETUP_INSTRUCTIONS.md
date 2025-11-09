# 🚀 Setup Instructions - Inventory Management System

## Prerequisites Installation

### 1. Install Java JDK 11 or higher
```bash
# Check if Java is installed
java -version

# If not installed, download from:
# https://www.oracle.com/java/technologies/downloads/
# OR install via Homebrew:
brew install openjdk@11
```

### 2. Install Maven (Optional - for building Java GUI)
```bash
brew install maven
```

### 3. MongoDB (Already Installed ✅)
```bash
brew services start mongodb-community@7.0
```

### 4. Python 3 (Already Installed ✅)
```bash
python3 --version
```

---

## 📦 Step-by-Step Setup

### STEP 1: Import UCI Dataset into MongoDB

```bash
cd /Users/devadharsanan/Documents/NoSQLJComp/python-api
python3 import_data.py
```

**Expected Output:**
```
📂 Reading Excel file...
📊 Total rows in dataset: 541909
🧹 Cleaning data...
✅ Clean rows: 397731
🗑️  Clearing existing data...
📦 Processing products...
✅ Inserted 3660 products
📊 Processing transactions...
✅ Inserted 10000 transactions
🔍 Creating indexes...

✨ Data import completed successfully!
📦 Total Products: 3660
📊 Total Transactions: 10000
```

---

### STEP 2: Start Python Flask API

```bash
cd /Users/devadharsanan/Documents/NoSQLJComp/python-api
python3 app.py
```

**Expected Output:**
```
🚀 Flask API starting on port 8000
📊 Dashboard: http://localhost:8000/api/dashboard/stats
📦 Products: http://localhost:8000/api/products
 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server.
 * Running on http://0.0.0.0:8000
```

**Keep this terminal running!**

---

### STEP 3: Test the API

Open a new terminal and run:

```bash
# Test health check
curl http://localhost:8000/api/health

# Test dashboard stats
curl http://localhost:8000/api/dashboard/stats | python3 -m json.tool

# Test products
curl "http://localhost:8000/api/products?limit=5" | python3 -m json.tool

# Test low stock
curl http://localhost:8000/api/products/low-stock | python3 -m json.tool
```

---

### STEP 4: Build and Run Java GUI

#### Option A: Using Maven (Recommended)

```bash
cd /Users/devadharsanan/Documents/NoSQLJComp/java-gui

# Build the project
mvn clean package

# Run the application
java -jar target/inventory-management-gui-1.0.0.jar
```

#### Option B: Using NetBeans IDE

1. **Open NetBeans**
2. **File → Open Project**
3. Navigate to `/Users/devadharsanan/Documents/NoSQLJComp/java-gui`
4. Select the project
5. **Right-click on project → Run**

#### Option C: Manual Compilation

```bash
cd /Users/devadharsanan/Documents/NoSQLJComp/java-gui

# Download dependencies and compile
./compile.sh

# Run the application
java -jar InventoryManagement.jar
```

---

## 🎯 What You Should See

### Python API (Terminal)
```
🚀 Flask API starting on port 8000
📊 Dashboard: http://localhost:8000/api/dashboard/stats
📦 Products: http://localhost:8000/api/products
 * Serving Flask app 'app'
 * Debug mode: on
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:8000
 * Running on http://192.168.1.x:8000
```

### Java GUI Application

**Window Title:** "Inventory Management System - MongoDB Dashboard"

**Tab 1: 📊 Dashboard**
- 5 stat cards showing:
  - Total Products: 3,660
  - Total Stock: 5,167,329
  - Total Value: £18,000,000+
  - Low Stock: ~100 items
  - Transactions: 10,000
- Pie chart: Products by Category
- Bar chart: Top 10 Countries

**Tab 2: 📦 All Products**
- Search bar
- Category filter dropdown
- Table with 100 products
- Columns: Stock Code, Description, Category, Price, Quantity, Value, Country

**Tab 3: ⚠️ Low Stock**
- Red warning header
- Table showing products with quantity < 10
- Refresh button

---

## 🔧 Troubleshooting

### Problem: MongoDB not running
```bash
brew services restart mongodb-community@7.0
brew services list | grep mongodb
```

### Problem: Port 8000 already in use
```bash
# Kill process on port 8000
lsof -ti:8000 | xargs kill -9

# OR change port in python-api/.env
# Change PORT=8000 to PORT=8001
# Then update Java code to use port 8001
```

### Problem: Python dependencies missing
```bash
cd python-api
pip3 install -r requirements.txt
```

### Problem: Java not found
```bash
# Install Java
brew install openjdk@11

# Add to PATH
echo 'export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Problem: Maven not found
```bash
brew install maven
mvn --version
```

### Problem: Java GUI not connecting to API
1. Make sure Flask API is running on port 8000
2. Check `http://localhost:8000/api/health` in browser
3. Check firewall settings

---

## 📊 Verify Everything is Working

### 1. Check MongoDB
```bash
mongosh inventory_db --eval "db.products.countDocuments()"
# Should return: 3660

mongosh inventory_db --eval "db.transactions.countDocuments()"
# Should return: 10000
```

### 2. Check Python API
```bash
curl http://localhost:8000/api/health
# Should return: {"status":"OK","database":"Connected",...}
```

### 3. Check Java GUI
- Dashboard should load with real numbers
- Charts should display
- Products table should show data
- Search should work

---

## 🎓 For Demonstration

### Before Starting Demo:

1. ✅ MongoDB running
2. ✅ Python API running (terminal visible)
3. ✅ Java GUI open and loaded
4. ✅ Browser tab open to `http://localhost:8000/api/dashboard/stats`

### Demo Script:

1. **Show Architecture** (1 min)
   - Explain 3-tier: Java GUI → Python API → MongoDB
   - Show project folder structure

2. **Show MongoDB Data** (1 min)
   ```bash
   mongosh inventory_db --eval "db.products.find().limit(3).pretty()"
   ```

3. **Show Python API** (1 min)
   - Show terminal with Flask running
   - Open browser: `http://localhost:8000/api/dashboard/stats`
   - Explain JSON response

4. **Show Java GUI** (5 min)
   - Dashboard tab: Explain each stat card
   - Show pie chart and bar chart
   - Products tab: Search for "bag"
   - Filter by category
   - Low Stock tab: Show alert system

5. **Show Code** (2 min)
   - Open `python-api/app.py` - show one endpoint
   - Open `java-gui/src/main/java/com/inventory/ui/MainFrame.java` - show GUI code

---

## 📁 Project Files Summary

### Python API Files
- `app.py` - Main Flask application (300 lines)
- `import_data.py` - Dataset importer (164 lines)
- `requirements.txt` - Dependencies
- `.env` - Configuration

### Java GUI Files
- `pom.xml` - Maven configuration
- `Product.java` - Product model
- `DashboardStats.java` - Stats model
- `ApiService.java` - API client
- `MainFrame.java` - Main GUI (450 lines)

### Documentation
- `COMPLETE_PROJECT_GUIDE.md` - Full project guide
- `SETUP_INSTRUCTIONS.md` - This file
- `README.md` - Original project README

---

## ✅ Final Checklist

Before submission/presentation:

- [ ] MongoDB is running
- [ ] Dataset imported (3,660 products)
- [ ] Python API starts without errors
- [ ] API endpoints return data
- [ ] Java GUI compiles successfully
- [ ] GUI connects to API
- [ ] Dashboard shows real data
- [ ] Charts display correctly
- [ ] Search functionality works
- [ ] Low stock alert works
- [ ] All documentation complete

---

## 🎉 Success Criteria

Your project is ready when:

✅ MongoDB has 3,660 products and 10,000 transactions  
✅ Python API responds to all endpoints  
✅ Java GUI displays dashboard with real data  
✅ Charts show category and country distribution  
✅ Search and filter work correctly  
✅ Low stock alerts display properly  

---

## 📞 Quick Commands Reference

```bash
# Start MongoDB
brew services start mongodb-community@7.0

# Import data
cd python-api && python3 import_data.py

# Start API
cd python-api && python3 app.py

# Build Java GUI
cd java-gui && mvn clean package

# Run Java GUI
cd java-gui && java -jar target/inventory-management-gui-1.0.0.jar

# Test API
curl http://localhost:8000/api/health
curl http://localhost:8000/api/dashboard/stats | python3 -m json.tool
```

---

**Project Status**: ✅ READY FOR DEMONSTRATION

**Last Updated**: November 5, 2025

