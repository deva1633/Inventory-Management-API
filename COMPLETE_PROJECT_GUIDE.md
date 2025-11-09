# 🎓 Complete Inventory Management System
## MongoDB + Python Flask API + Java NetBeans GUI

A complete 3-tier inventory management system using real UCI Online Retail dataset.

---

## 📊 Project Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Java NetBeans GUI                         │
│              (Desktop Application - Swing)                   │
│   📊 Dashboard | 📦 Products | ⚠️ Low Stock Alerts          │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTP REST API
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   Python Flask API                           │
│              (REST API Server - Port 8000)                   │
│   /api/dashboard/stats | /api/products | /api/search        │
└────────────────────────┬────────────────────────────────────┘
                         │ PyMongo
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      MongoDB Database                        │
│                   (inventory_db)                             │
│   📦 products (3,660) | 📊 transactions (10,000)            │
└─────────────────────────────────────────────────────────────┘
```

---

## 🗂️ Project Structure

```
NoSQLJComp/
├── python-api/                    # Python Flask REST API
│   ├── app.py                     # Main Flask application
│   ├── import_data.py             # UCI dataset importer
│   ├── requirements.txt           # Python dependencies
│   └── .env                       # Configuration
│
├── java-gui/                      # Java NetBeans GUI
│   ├── pom.xml                    # Maven configuration
│   └── src/main/java/com/inventory/
│       ├── models/                # Data models
│       │   ├── Product.java
│       │   └── DashboardStats.java
│       ├── services/              # API service layer
│       │   └── ApiService.java
│       └── ui/                    # GUI components
│           └── MainFrame.java     # Main application window
│
├── Online Retail.xlsx             # UCI dataset (541K+ rows)
└── COMPLETE_PROJECT_GUIDE.md      # This file
```

---

## 🚀 Quick Start Guide

### Step 1: Start MongoDB
```bash
brew services start mongodb-community@7.0
```

### Step 2: Import UCI Dataset
```bash
cd python-api
python3 import_data.py
```

**Output:**
```
📂 Reading Excel file...
📊 Total rows in dataset: 541909
🧹 Cleaning data...
✅ Clean rows: 397731
📦 Processing products...
✅ Inserted 3660 products
📊 Processing transactions...
✅ Inserted 10000 transactions
✨ Data import completed successfully!
```

### Step 3: Start Python Flask API
```bash
cd python-api
python3 app.py
```

**Server runs at:** http://localhost:8000

### Step 4: Run Java GUI Application

**Option A: Using Maven (Command Line)**
```bash
cd java-gui
mvn clean package
java -jar target/inventory-management-gui-1.0.0.jar
```

**Option B: Using NetBeans IDE**
1. Open NetBeans
2. File → Open Project → Select `java-gui` folder
3. Right-click project → Run

---

## 📊 Real Dataset Statistics

### UCI Online Retail Dataset
- **Source**: UCI Machine Learning Repository
- **Total Rows**: 541,909 transactions
- **Date Range**: 2010-2011
- **Countries**: 38 countries
- **Unique Products**: 3,660 items

### Imported Data
- **Products**: 3,660 unique items
- **Transactions**: 10,000 sample transactions
- **Categories**: 11 auto-categorized groups
- **Total Stock Units**: 5,167,329 items
- **Total Inventory Value**: £18,000,000+

### Category Distribution
1. General Merchandise: 1,431 products
2. Home Decor: 683 products
3. Bags & Storage: 399 products
4. Stationery: 250 products
5. Kitchen & Dining: 228 products
6. Jewelry & Accessories: 186 products
7. Candles & Lights: 167 products
8. Garden: 159 products
9. Textiles: 71 products
10. Toys & Games: 50 products
11. Party Supplies: 36 products

---

## 🎯 Features Implemented

### Python Flask API (Backend)
✅ **Dashboard Statistics**
- Total products, stock, value
- Low stock count
- Transaction count
- Category distribution
- Country distribution

✅ **Product Management**
- Get all products (with pagination)
- Search products
- Filter by category/country
- Low stock alerts

✅ **Data Endpoints**
- `/api/health` - Health check
- `/api/dashboard/stats` - Dashboard data
- `/api/products` - All products
- `/api/products/low-stock` - Low stock items
- `/api/categories` - All categories
- `/api/countries` - All countries
- `/api/search?q=query` - Search products

### Java GUI (Frontend)
✅ **Dashboard Tab**
- 5 stat cards (Products, Stock, Value, Low Stock, Transactions)
- Pie chart: Products by Category
- Bar chart: Top 10 Countries
- Real-time data from API

✅ **All Products Tab**
- Searchable product table
- Category filter dropdown
- Displays: Stock Code, Description, Category, Price, Quantity, Value, Country
- Refresh button

✅ **Low Stock Tab**
- Alert table for products with quantity < 10
- Highlighted warning display
- Refresh functionality

---

## 🔧 Technology Stack

### Backend (Python)
- **Flask 3.0.0** - Web framework
- **PyMongo 4.6.0** - MongoDB driver
- **Pandas 2.2+** - Data processing
- **OpenPyXL 3.1.2** - Excel file reading

### Frontend (Java)
- **Java 11+** - Programming language
- **Swing** - GUI framework
- **Maven** - Build tool
- **Gson 2.10.1** - JSON parsing
- **Apache HttpClient 5.2.1** - HTTP requests
- **JFreeChart 1.5.4** - Charts and graphs

### Database
- **MongoDB 7.0** - NoSQL database

---

## 📱 GUI Screenshots Description

### Dashboard Tab
- **Top Section**: 5 colorful stat cards showing key metrics
- **Bottom Section**: 
  - Left: Pie chart showing category distribution
  - Right: Bar chart showing top 10 countries

### All Products Tab
- **Search Bar**: Real-time product search
- **Category Filter**: Dropdown to filter by category
- **Table**: 7 columns with 100 products displayed
- **Refresh Button**: Reload data from API

### Low Stock Tab
- **Warning Header**: Red alert banner
- **Table**: Products with quantity < 10
- **Refresh Button**: Update low stock list

---

## 🎓 For College Presentation

### Key Points to Highlight

1. **3-Tier Architecture**
   - Separation of concerns
   - Scalable design
   - Professional industry standard

2. **Real Dataset**
   - 541K+ actual transactions
   - UCI Machine Learning Repository
   - Real-world business data

3. **Modern Technologies**
   - Python Flask (Backend)
   - Java Swing (Frontend)
   - MongoDB (Database)
   - RESTful API design

4. **Complete Features**
   - Dashboard with statistics
   - Product management
   - Low stock alerts
   - Search and filter
   - Data visualization (charts)

5. **Data Processing**
   - Automatic categorization
   - Data cleaning
   - Aggregation pipelines
   - Real-time calculations

### Demo Flow (10 minutes)

1. **Show Architecture** (1 min)
   - Explain 3-tier design
   - Show project structure

2. **Start Backend** (1 min)
   - Start MongoDB
   - Start Flask API
   - Show API endpoints in browser

3. **Launch GUI** (1 min)
   - Open Java application
   - Show professional interface

4. **Dashboard Demo** (2 min)
   - Explain stat cards
   - Show pie chart (categories)
   - Show bar chart (countries)

5. **Products Demo** (2 min)
   - Search for products
   - Filter by category
   - Show table data

6. **Low Stock Demo** (1 min)
   - Show alert system
   - Explain business value

7. **Code Walkthrough** (2 min)
   - Show Python API code
   - Show Java GUI code
   - Explain MongoDB queries

---

## 📊 API Testing

### Test Dashboard Stats
```bash
curl http://localhost:8000/api/dashboard/stats | python3 -m json.tool
```

### Test Products
```bash
curl "http://localhost:8000/api/products?limit=10" | python3 -m json.tool
```

### Test Search
```bash
curl "http://localhost:8000/api/search?q=bag" | python3 -m json.tool
```

### Test Low Stock
```bash
curl http://localhost:8000/api/products/low-stock | python3 -m json.tool
```

---

## 🏆 Project Advantages

### Why This Stack?

1. **Java NetBeans GUI**
   - ✅ Professional desktop application
   - ✅ Easy to use for non-technical users
   - ✅ No browser required
   - ✅ Better performance than web apps
   - ✅ Familiar for college projects

2. **Python Flask API**
   - ✅ Simple and clean code
   - ✅ Easy to understand
   - ✅ Fast development
   - ✅ Great for data processing
   - ✅ Industry standard

3. **MongoDB Database**
   - ✅ Flexible schema
   - ✅ Fast queries
   - ✅ JSON-like documents
   - ✅ Easy aggregation
   - ✅ Scalable

---

## 🛠️ Troubleshooting

### MongoDB Not Starting
```bash
brew services restart mongodb-community@7.0
```

### Port 8000 Already in Use
Edit `python-api/.env` and change PORT to 8001, then update Java code

### Java Compilation Errors
```bash
cd java-gui
mvn clean install -U
```

### Python Dependencies Issues
```bash
cd python-api
pip3 install --upgrade -r requirements.txt
```

---

## 📚 Learning Outcomes

Students will learn:
1. ✅ 3-tier architecture design
2. ✅ RESTful API development
3. ✅ MongoDB database operations
4. ✅ Java Swing GUI programming
5. ✅ HTTP client-server communication
6. ✅ JSON data handling
7. ✅ Data visualization with charts
8. ✅ Real dataset processing
9. ✅ Maven build system
10. ✅ Professional project structure

---

## 🎯 Grading Criteria Met

✅ **Functionality** - All features working  
✅ **Code Quality** - Clean, organized, commented  
✅ **Real Data** - UCI dataset with 541K+ rows  
✅ **User Interface** - Professional GUI with charts  
✅ **Documentation** - Complete guides and README  
✅ **Technology Stack** - Modern, industry-standard  
✅ **Architecture** - Proper 3-tier separation  
✅ **Innovation** - Auto-categorization, real-time stats  

---

## 📞 Quick Reference

| Component | Port | URL |
|-----------|------|-----|
| MongoDB | 27017 | mongodb://localhost:27017 |
| Flask API | 8000 | http://localhost:8000 |
| Java GUI | - | Desktop Application |

| Dataset | Count |
|---------|-------|
| Products | 3,660 |
| Transactions | 10,000 |
| Categories | 11 |
| Countries | 38 |

---

**Project Status**: ✅ COMPLETE & READY FOR DEMONSTRATION

**Last Updated**: November 5, 2025

