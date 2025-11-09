# MongoDB Commands Reference (mongosh)

Quick reference for checking your Inventory Management System database.

## Basic Connection

```bash
# Connect to MongoDB
mongosh

# Or connect directly to your database
mongosh mongodb://localhost:27017/inventory_db

# Or specify database after connection
mongosh
use inventory_db
```

---

## Database Operations

```bash
# Show all databases
show dbs

# Show current database
db

# Switch to inventory_db
use inventory_db

# Show database statistics
db.stats()

# Drop current database (⚠️ DANGEROUS - deletes everything!)
# db.dropDatabase()
```

---

## Collection Operations

```bash
# Show all collections in current database
show collections

# Or alternatively
db.getCollectionNames()

# Count documents in a collection
db.products.countDocuments()
db.categories.countDocuments()
db.suppliers.countDocuments()
db.transactions.countDocuments()

# Get collection statistics
db.products.stats()
db.categories.stats()
```

---

## View Data

### Products Collection

```bash
# View all products
db.products.find()

# View products in pretty format
db.products.find().pretty()

# View first 5 products
db.products.find().limit(5).pretty()

# Count total products
db.products.countDocuments()

# Count products by category
db.products.aggregate([
  { $group: { _id: "$category", count: { $sum: 1 } } }
])

# Find products with low stock (quantity <= reorderLevel)
db.products.find({ 
  $expr: { $lte: ["$quantity", "$reorderLevel"] } 
}).pretty()

# Find products by status
db.products.find({ status: "active" }).pretty()

# Search products by name
db.products.find({ 
  name: { $regex: "laptop", $options: "i" } 
}).pretty()
```

### Categories Collection

```bash
# View all categories
db.categories.find().pretty()

# Count categories
db.categories.countDocuments()

# Find category by name
db.categories.find({ name: "Electronics" }).pretty()
```

### Suppliers Collection

```bash
# View all suppliers
db.suppliers.find().pretty()

# Count suppliers
db.suppliers.countDocuments()

# Find suppliers by country
db.suppliers.find({ 
  "address.country": "India" 
}).pretty()

# Find active suppliers
db.suppliers.find({ status: "active" }).pretty()
```

### Transactions Collection

```bash
# View all transactions
db.transactions.find().pretty()

# Count transactions
db.transactions.countDocuments()

# View recent transactions (last 10)
db.transactions.find()
  .sort({ createdAt: -1 })
  .limit(10)
  .pretty()

# Count transactions by type
db.transactions.aggregate([
  { $group: { _id: "$type", count: { $sum: 1 } } }
])
```

---

## Aggregation Queries (Dashboard Stats)

### Category Distribution

```bash
db.products.aggregate([
  { $group: { _id: "$category", count: { $sum: 1 } } },
  {
    $lookup: {
      from: "categories",
      localField: "_id",
      foreignField: "_id",
      as: "cat"
    }
  },
  { $unwind: { path: "$cat", preserveNullAndEmptyArrays: true } },
  {
    $project: {
      _id: { $ifNull: ["$cat.name", "Uncategorized"] },
      count: 1
    }
  },
  { $sort: { count: -1 } }
])
```

### Country Distribution

```bash
db.products.aggregate([
  { $match: { supplier: { $ne: null } } },
  {
    $lookup: {
      from: "suppliers",
      localField: "supplier",
      foreignField: "_id",
      as: "sup"
    }
  },
  { $unwind: { path: "$sup", preserveNullAndEmptyArrays: true } },
  {
    $group: {
      _id: { $ifNull: ["$sup.address.country", "Unknown"] },
      count: { $sum: 1 }
    }
  },
  { $sort: { count: -1 } }
])
```

### Top Products by Stock Value

```bash
db.products.aggregate([
  {
    $addFields: {
      stockValue: { $multiply: ["$quantity", "$price"] }
    }
  },
  { $sort: { stockValue: -1 } },
  { $limit: 10 },
  {
    $project: {
      name: 1,
      sku: 1,
      quantity: 1,
      price: 1,
      stockValue: 1
    }
  }
])
```

### Inventory Summary

```bash
db.products.aggregate([
  {
    $group: {
      _id: null,
      totalProducts: { $sum: 1 },
      totalStock: { $sum: "$quantity" },
      totalValue: { 
        $sum: { $multiply: ["$quantity", "$price"] } 
      },
      lowStockCount: {
        $sum: {
          $cond: [{ $lte: ["$quantity", "$reorderLevel"] }, 1, 0]
        }
      },
      avgPrice: { $avg: "$price" },
      avgQuantity: { $avg: "$quantity" }
    }
  }
])
```

---

## Index Information

```bash
# List all indexes on products collection
db.products.getIndexes()

# List all indexes on categories collection
db.categories.getIndexes()

# Check index usage statistics
db.products.aggregate([{ $indexStats: {} }])
```

---

## Data Validation

### Check for Missing Required Fields

```bash
# Products without category
db.products.find({ category: null }).count()

# Products without price
db.products.find({ price: { $exists: false } }).count()

# Products with negative quantity
db.products.find({ quantity: { $lt: 0 } }).count()
```

### Check Data Types

```bash
# Check product schema
db.products.findOne()

# Check if price is number
db.products.find({ 
  price: { $type: "number" } 
}).count()
```

---

## Quick Stats Summary

```bash
# Run this to get a complete overview
use inventory_db

print("\n=== DATABASE OVERVIEW ===\n");
print("Total Products: " + db.products.countDocuments());
print("Total Categories: " + db.categories.countDocuments());
print("Total Suppliers: " + db.suppliers.countDocuments());
print("Total Transactions: " + db.transactions.countDocuments());

print("\n=== PRODUCT STATS ===\n");
db.products.aggregate([
  {
    $group: {
      _id: null,
      totalStock: { $sum: "$quantity" },
      totalValue: { $sum: { $multiply: ["$quantity", "$price"] } },
      lowStockCount: {
        $sum: { $cond: [{ $lte: ["$quantity", "$reorderLevel"] }, 1, 0] }
      }
    }
  }
]).forEach(function(doc) {
  print("Total Stock Units: " + doc.totalStock);
  print("Total Inventory Value: $" + doc.totalValue.toFixed(2));
  print("Low Stock Items: " + doc.lowStockCount);
});

print("\n=== CATEGORY BREAKDOWN ===\n");
db.products.aggregate([
  { $group: { _id: "$category", count: { $sum: 1 } } },
  {
    $lookup: {
      from: "categories",
      localField: "_id",
      foreignField: "_id",
      as: "cat"
    }
  },
  { $unwind: { path: "$cat", preserveNullAndEmptyArrays: true } },
  {
    $project: {
      name: { $ifNull: ["$cat.name", "Uncategorized"] },
      count: 1
    }
  },
  { $sort: { count: -1 } }
]).forEach(function(doc) {
  print(doc.name + ": " + doc.count + " products");
});
```

---

## Export/Import Commands

```bash
# Export products to JSON
mongosh inventory_db --quiet --eval "db.products.find().toArray()" > products.json

# Export specific query
mongosh inventory_db --quiet --eval "db.products.find({ status: 'active' }).toArray()" > active-products.json

# Count and display
mongosh inventory_db --quiet --eval "print(db.products.countDocuments())"
```

---

## Useful One-Liners

```bash
# Quick product count
mongosh inventory_db --quiet --eval "db.products.countDocuments()"

# Check if database exists
mongosh --quiet --eval "db.adminCommand('listDatabases').databases.find(d => d.name === 'inventory_db')"

# Get collection sizes
mongosh inventory_db --quiet --eval "db.stats(1024*1024)"

# Find duplicates (if SKU should be unique)
db.products.aggregate([
  { $group: { _id: "$sku", count: { $sum: 1 } } },
  { $match: { count: { $gt: 1 } } }
])
```

---

## Troubleshooting

```bash
# Check MongoDB connection
mongosh --eval "db.adminCommand('ping')"

# Check database connection status
mongosh inventory_db --eval "db.getMongo()"

# View recent operations
mongosh inventory_db --eval "db.currentOp()"

# Check for errors in logs
# (Check MongoDB log file location)
```

---

## Quick Reference Card

| Command | Purpose |
|---------|---------|
| `show dbs` | List all databases |
| `use inventory_db` | Switch to inventory database |
| `show collections` | List all collections |
| `db.products.find().pretty()` | View all products |
| `db.products.countDocuments()` | Count products |
| `db.products.findOne()` | Get one product sample |
| `db.products.stats()` | Collection statistics |

