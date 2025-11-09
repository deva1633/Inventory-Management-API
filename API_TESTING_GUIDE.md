# 🧪 API Testing Guide

Complete guide to test all API endpoints using curl commands.

## 🏥 Health Check

```bash
# Check if server is running
curl http://localhost:3000/api/health

# Expected Response:
{
  "status": "OK",
  "database": "Connected",
  "timestamp": "2025-11-05T09:20:28.014Z"
}
```

## 📦 Categories API

### Get All Categories
```bash
curl http://localhost:3000/api/categories
```

### Get Category by ID
```bash
# Replace <category_id> with actual ID from previous response
curl http://localhost:3000/api/categories/<category_id>
```

### Create New Category
```bash
curl -X POST http://localhost:3000/api/categories \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Sports Equipment",
    "description": "Sports and fitness equipment"
  }'
```

### Update Category
```bash
curl -X PUT http://localhost:3000/api/categories/<category_id> \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Updated description for sports equipment"
  }'
```

### Delete Category
```bash
curl -X DELETE http://localhost:3000/api/categories/<category_id>
```

## 🏢 Suppliers API

### Get All Suppliers
```bash
curl http://localhost:3000/api/suppliers
```

### Get Supplier by ID (with products)
```bash
curl http://localhost:3000/api/suppliers/<supplier_id>
```

### Create New Supplier
```bash
curl -X POST http://localhost:3000/api/suppliers \
  -H "Content-Type: application/json" \
  -d '{
    "name": "New Tech Suppliers",
    "contactPerson": "John Doe",
    "email": "john@newtech.com",
    "phone": "+91-9999999999",
    "address": {
      "street": "456 Tech Street",
      "city": "Chennai",
      "state": "Tamil Nadu",
      "zipCode": "600001",
      "country": "India"
    }
  }'
```

### Update Supplier
```bash
curl -X PUT http://localhost:3000/api/suppliers/<supplier_id> \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "+91-8888888888",
    "email": "newemail@newtech.com"
  }'
```

## 📱 Products API

### Get All Products
```bash
curl http://localhost:3000/api/products
```

### Search Products
```bash
# Search by name or SKU
curl "http://localhost:3000/api/products?search=laptop"

# Filter by category
curl "http://localhost:3000/api/products?category=<category_id>"

# Filter by status
curl "http://localhost:3000/api/products?status=active"

# Combine filters
curl "http://localhost:3000/api/products?search=mouse&status=active"
```

### Get Low Stock Products
```bash
curl http://localhost:3000/api/products/low-stock
```

### Get Inventory Summary
```bash
curl http://localhost:3000/api/products/summary/stats

# Expected Response:
{
  "success": true,
  "data": {
    "totalProducts": 12,
    "totalStockUnits": 676,
    "totalStockValue": "2272300.00",
    "lowStockCount": 2,
    "outOfStockCount": 0,
    "activeProducts": 12
  }
}
```

### Get Product by ID
```bash
curl http://localhost:3000/api/products/<product_id>
```

### Create New Product
```bash
# First, get a category ID and supplier ID from previous calls
# Then create product:

curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Wireless Gaming Mouse",
    "sku": "ACC-MOUSE-GAME-001",
    "description": "RGB wireless gaming mouse with 6 buttons",
    "category": "<category_id>",
    "supplier": "<supplier_id>",
    "quantity": 75,
    "reorderLevel": 15,
    "price": 1500,
    "cost": 1000,
    "status": "active"
  }'
```

### Update Product
```bash
curl -X PUT http://localhost:3000/api/products/<product_id> \
  -H "Content-Type: application/json" \
  -d '{
    "quantity": 100,
    "price": 1600
  }'
```

### Delete Product
```bash
curl -X DELETE http://localhost:3000/api/products/<product_id>
```

## 📊 Transactions API

### Get All Transactions
```bash
curl http://localhost:3000/api/transactions
```

### Filter Transactions
```bash
# By product
curl "http://localhost:3000/api/transactions?product=<product_id>"

# By type
curl "http://localhost:3000/api/transactions?type=in"
curl "http://localhost:3000/api/transactions?type=out"
curl "http://localhost:3000/api/transactions?type=adjustment"
```

### Create Stock IN Transaction
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "product": "<product_id>",
    "type": "in",
    "quantity": 50,
    "reason": "New stock purchase from supplier",
    "reference": "PO-2024-100"
  }'

# This will INCREASE the product quantity by 50
```

### Create Stock OUT Transaction
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "product": "<product_id>",
    "type": "out",
    "quantity": 10,
    "reason": "Customer order fulfilled",
    "reference": "INV-2024-500"
  }'

# This will DECREASE the product quantity by 10
```

### Create Stock ADJUSTMENT Transaction
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "product": "<product_id>",
    "type": "adjustment",
    "quantity": 100,
    "reason": "Physical inventory count correction",
    "reference": "ADJ-2024-001"
  }'

# This will SET the product quantity to exactly 100
```

## 🎯 Complete Testing Workflow

### Step 1: Check Server Health
```bash
curl http://localhost:3000/api/health
```

### Step 2: Get All Categories (save an ID)
```bash
curl http://localhost:3000/api/categories | python3 -m json.tool
# Copy a category _id from response
```

### Step 3: Get All Suppliers (save an ID)
```bash
curl http://localhost:3000/api/suppliers | python3 -m json.tool
# Copy a supplier _id from response
```

### Step 4: Create a New Product
```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Product",
    "sku": "TEST-001",
    "description": "This is a test product",
    "category": "690b16a00d001f7efc660877",
    "supplier": "690b16a00d001f7efc66087a",
    "quantity": 50,
    "reorderLevel": 10,
    "price": 1000,
    "cost": 700,
    "status": "active"
  }' | python3 -m json.tool

# Copy the product _id from response
```

### Step 5: Record a Transaction
```bash
curl -X POST http://localhost:3000/api/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "product": "<product_id_from_step_4>",
    "type": "in",
    "quantity": 25,
    "reason": "Additional stock received",
    "reference": "PO-TEST-001"
  }' | python3 -m json.tool
```

### Step 6: Verify Product Quantity Updated
```bash
curl http://localhost:3000/api/products/<product_id_from_step_4> | python3 -m json.tool
# Quantity should now be 75 (50 + 25)
```

### Step 7: Check Low Stock Products
```bash
curl http://localhost:3000/api/products/low-stock | python3 -m json.tool
```

### Step 8: Get Inventory Summary
```bash
curl http://localhost:3000/api/products/summary/stats | python3 -m json.tool
```

## 🔍 Pretty Print JSON Responses

Add `| python3 -m json.tool` to any curl command for formatted output:

```bash
curl http://localhost:3000/api/products | python3 -m json.tool
```

Or use `jq` if installed:
```bash
curl http://localhost:3000/api/products | jq
```

## ⚠️ Common Error Responses

### 404 Not Found
```json
{
  "success": false,
  "message": "Product not found"
}
```

### 400 Bad Request
```json
{
  "success": false,
  "message": "SKU already exists"
}
```

### 400 Insufficient Stock
```json
{
  "success": false,
  "message": "Insufficient stock"
}
```

### 400 Cannot Delete
```json
{
  "success": false,
  "message": "Cannot delete. 5 products use this category"
}
```

## 📝 Notes

- Replace `<category_id>`, `<supplier_id>`, `<product_id>` with actual MongoDB ObjectIds
- All POST/PUT requests require `Content-Type: application/json` header
- Transaction creation automatically updates product quantities
- Deleting a product also deletes all its transactions
- Cannot delete categories/suppliers that have associated products

## 🎓 For College Presentation

**Demonstrate these key features:**

1. ✅ **CRUD Operations**: Show create, read, update, delete for products
2. ✅ **Low Stock Alert**: Display products below reorder level
3. ✅ **Transaction Logging**: Record stock movements and show quantity updates
4. ✅ **Inventory Summary**: Show total value and statistics
5. ✅ **Data Relationships**: Show how products link to categories and suppliers
6. ✅ **Search & Filter**: Demonstrate query parameters
7. ✅ **Error Handling**: Show validation errors and constraints

---

**Happy Testing! 🚀**

