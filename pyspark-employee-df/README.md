# PySpark Sales Analysis (Docker + Spark + Jupyter)

## 🚀 Project Overview

This project demonstrates a **data processing pipeline using PySpark** inside a **Dockerized environment**.
It performs basic sales analytics like sorting, filtering, and top-N analysis on an employee/sales dataset.

The workflow is designed to simulate a lightweight **big data processing setup** using Apache Spark.

---

## 🏗️ Tech Stack

* Python 3.12
* Apache Spark 3.5.6
* PySpark
* Docker
* JupyterLab

---

## 📁 Project Structure

```
.
├── Dockerfile
├── app
│   └── spark-app.py
├── employee.csv
├── output/
├── requirements.txt
└── Untitled.ipynb
```

---

## ⚙️ Features Implemented

* Load CSV data using Spark DataFrame
* Sort products by sales (descending)
* Extract Top 3 highest-selling products
* Filter records with sales > 80,000
* Save processed outputs to files

---

## 🐳 How to Run the Project

### 1. Build Docker Image

```bash
docker build -t spark-sales-app .
```

### 2. Run Container (with port mapping for Jupyter)

```bash
docker run -p 8080:8080 spark-sales-app
```

### 3. Open JupyterLab

Go to:

```
http://localhost:8080/lab
```

---

## 📊 Output Generated

After execution, results are stored in:

```
/workspace/output/
```

### Includes:

* filtered_sales/ → Products with sales > 80,000
* sorted_sales/ → All products sorted by sales
* top3_sales/ → Top 3 products
* results.txt → Console-style formatted output

---

