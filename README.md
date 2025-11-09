# 📦 Inventory Management System API (Node.js + Express + MongoDB)

A complete **Inventory Management System API** built with **Node.js**, **Express**, and **MongoDB**.  
It provides endpoints for managing **categories**, **suppliers**, **products**, and **transactions**, along with **dashboard statistics**, **stock summaries**, and **health monitoring**.  

This backend is designed to power real-time inventory dashboards and analytics tools.

---

## 🚀 Features

✅ **Category Management** — Create, update, list, and delete categories.  
✅ **Supplier Management** — Maintain supplier details with country and contact info.  
✅ **Product Management** — Handle product creation, updates, filters, and stock tracking.  
✅ **Transaction Management** — Record stock in/out/adjustment operations.  
✅ **Dashboard Analytics** — Get summary stats like total stock, low-stock count, and top products.  
✅ **Search & Filter Support** — Query products by category, supplier, name, or SKU.  
✅ **MongoDB Aggregations** — For real-time analytics and summarized dashboards.  
✅ **Error Handling & Validation** — Clean error responses with consistent JSON output.  

---

## 🧠 Tech Stack

| Component | Technology |
|------------|-------------|
| Backend Framework | **Express.js** |
| Database | **MongoDB + Mongoose ODM** |
| Environment Config | **dotenv** |
| CORS Middleware | **cors** |
| Language | **Node.js (JavaScript)** |

---

📁 inventory-management-api/
├── models/
│   ├── Category.js
│   ├── Supplier.js
│   ├── Product.js
│   └── Transaction.js
├── .env
├── server.js
├── package.json
└── README.md
