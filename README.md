# 📦 Inventory Management System - MongoDB Project

A complete **MongoDB-based Inventory Management System** built with Node.js, Express, and Mongoose for college project demonstration.

## 🎯 Project Overview

This system manages inventory operations including:
- ✅ Product catalog management
- ✅ Category and supplier tracking
- ✅ Stock level monitoring with low-stock alerts
- ✅ Transaction logging (stock in/out/adjustments)
- ✅ Real-time inventory valuation
- ✅ RESTful API architecture

## 📁 Simplified Project Structure

```
NoSQLJComp/
├── backend/
│   ├── models/              # Mongoose schemas (4 files)
│   │   ├── Category.js
│   │   ├── Supplier.js
│   │   ├── Product.js
│   │   └── Transaction.js
│   ├── config/
│   │   └── database.js      # MongoDB connection
│   ├── server.js            # Main server with all routes (single file!)
│   ├── seedData.js          # Sample data seeder
│   ├── importUCIData.js     # UCI dataset importer
│   ├── package.json
│   └── .env
├── Online Retail.xlsx       # UCI dataset (540K+ transactions)
└── README.md
```

**Total Core Files: Only 10 files!** (Simplified from typical 20+ file structure)

## 🚀 Quick Start

### Prerequisites
- Node.js (v14+)
- MongoDB (installed via Homebrew)

### Installation

1. **Start MongoDB**
```bash
brew services start mongodb-community@7.0
```

2. **Install Dependencies**
```bash
cd backend
npm install
```

3. **Seed Sample Data**
```bash
npm run seed
```

4. **Start Server**
```bash
npm start
```

Server runs at: **http://localhost:8000**

### Run the Java Swing Dashboard (GUI)

```bash
# Build the GUI (requires Java 17 and Maven)
cd ../java-gui
mvn -q -DskipTests clean package

# Run the desktop app
java -jar target/inventory-management-gui-1.0.0-shaded.jar

# Optional: override API base URL
# java -DapiBaseUrl="http://localhost:8000/api" -jar target/inventory-management-gui-1.0.0-shaded.jar
```

## 📊 Available Scripts

| Command | Description |
|---------|-------------|
| `npm start` | Start the server |
| `npm run dev` | Start with nodemon (auto-reload) |
| `npm run seed` | Populate database with 12 sample products |
| `npm run import` | Import UCI Online Retail dataset |

## 🔌 API Endpoints

### Health Check
```bash
GET /api/health
```

### Categories
```bash
GET    /api/categories          # Get all categories
GET    /api/categories/:id      # Get category by ID
POST   /api/categories          # Create category
PUT    /api/categories/:id      # Update category
DELETE /api/categories/:id      # Delete category
```

### Suppliers
```bash
GET    /api/suppliers           # Get all suppliers
GET    /api/suppliers/:id       # Get supplier by ID
POST   /api/suppliers           # Create supplier
PUT    /api/suppliers/:id       # Update supplier
DELETE /api/suppliers/:id       # Delete supplier
```

### Products
```bash
GET    /api/products                    # Get all products
GET    /api/products/low-stock          # Get low stock products
GET    /api/products/summary/stats      # Get inventory summary
GET    /api/products/:id                # Get product by ID
POST   /api/products                    # Create product
PUT    /api/products/:id                # Update product
DELETE /api/products/:id                # Delete product

# Query Parameters:
?search=laptop          # Search by name/SKU
?category=<id>          # Filter by category
?supplier=<id>          # Filter by supplier
?status=active          # Filter by status
```

### Transactions
```bash
GET    /api/transactions        # Get all transactions
GET    /api/transactions/:id    # Get transaction by ID
POST   /api/transactions        # Create transaction (updates stock)

# Query Parameters:
?product=<id>           # Filter by product
?type=in                # Filter by type (in/out/adjustment)
```

## 📝 API Usage Examples

### 1. Get All Products
```bash
curl http://localhost:8000/api/products
```

### 2. Get Low Stock Products
```bash
curl http://localhost:8000/api/products/low-stock
```

### 3. Get Inventory Summary
```bash
curl http://localhost:8000/api/products/summary/stats
```

### 4. Create New Product
```bash
curl -X POST http://localhost:8000/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Wireless Headphones",
    "sku": "ACC-HP-001",
    "description": "Bluetooth wireless headphones",
    "category": "<category_id>",
    "supplier": "<supplier_id>",
    "quantity": 50,
    "reorderLevel": 10,
    "price": 2500,
    "cost": 1800,
    "status": "active"
  }'
```

### 5. Record Stock Transaction
```bash
curl -X POST http://localhost:8000/api/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "product": "<product_id>",
    "type": "in",
    "quantity": 100,
    "reason": "New stock purchase",
    "reference": "PO-2024-001"
  }'
```

## 🗄️ Database Schema

### Product Schema
```javascript
{
  name: String (required),
  sku: String (required, unique),
  description: String,
  category: ObjectId (ref: Category),
  supplier: ObjectId (ref: Supplier),
  quantity: Number (default: 0),
  reorderLevel: Number (default: 10),
  price: Number (required),
  cost: Number (required),
  status: String (active/inactive/discontinued)
}
```

### Transaction Schema
```javascript
{
  product: ObjectId (ref: Product),
  type: String (in/out/adjustment),
  quantity: Number,
  reason: String,
  reference: String,
  previousQuantity: Number,
  newQuantity: Number
}
```

## 🎓 Key Features for College Project

### 1. **Low Stock Alert System**
Automatically identifies products below reorder level:
```bash
GET /api/products/low-stock
```

### 2. **Inventory Valuation**
Real-time calculation of total inventory value:
```bash
GET /api/products/summary/stats
```

### 3. **Transaction Logging**
Complete audit trail of all stock movements with automatic quantity updates.

### 4. **Data Relationships**
Demonstrates MongoDB references between collections (Products → Categories, Suppliers).

### 5. **Real Dataset Integration**
Import 540K+ transactions from UCI Online Retail dataset:
```bash
npm run import
```

## 📈 Sample Data Included

After running `npm run seed`:
- **5 Categories**: Electronics, Office Supplies, Furniture, Accessories, Kitchen & Dining
- **3 Suppliers**: Tech Distributors, Office Mart, Global Electronics
- **12 Products**: Laptops, mice, keyboards, furniture, office supplies
- **3 Sample Transactions**: Stock in/out examples

## 🔧 Technology Stack

- **Backend**: Node.js + Express.js
- **Database**: MongoDB + Mongoose ODM
- **Data Processing**: xlsx (for Excel import)
- **Architecture**: RESTful API, MVC pattern

## 📊 MongoDB Advantages Demonstrated

1. **Flexible Schema**: Easy to add new fields without migrations
2. **Document References**: Efficient relationships using ObjectId
3. **Embedded Documents**: Supplier addresses stored within supplier documents
4. **Virtual Properties**: Calculated fields (isLowStock, stockValue, profitMargin)
5. **Indexing**: Fast queries on SKU, category, supplier
6. **Aggregation**: Category-wise statistics and reporting

## 🎯 Project Highlights for Presentation

1. ✅ **Simplified Architecture**: Only 10 core files vs typical 20+ files
2. ✅ **Single Server File**: All routes in one place for easy understanding
3. ✅ **Real Dataset**: 540K+ transactions from UCI repository
4. ✅ **Complete CRUD**: All operations for all entities
5. ✅ **Business Logic**: Low stock alerts, inventory valuation
6. ✅ **Data Validation**: Mongoose schema validation
7. ✅ **Error Handling**: Comprehensive error responses
8. ✅ **RESTful Design**: Industry-standard API patterns

## 🛑 Stop MongoDB

```bash
brew services stop mongodb-community@7.0
```

## 📚 Additional Resources

- MongoDB Documentation: https://docs.mongodb.com/
- Mongoose Documentation: https://mongoosejs.com/
- Express.js Guide: https://expressjs.com/
- UCI Dataset: https://archive.ics.uci.edu/ml/datasets/online+retail

## 👨‍💻 Author

College Project - NoSQL Database Management System

---

**Note**: This is a simplified, educational implementation focused on demonstrating MongoDB concepts and REST API design for college-level understanding.

