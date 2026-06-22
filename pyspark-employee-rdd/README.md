# PySpark Employee RDD (RDD + Docker)

## Overview
This project uses PySpark RDDs to process an employee dataset inside a Docker container. It performs sorting, aggregation, and top-3 salary extraction.

## Tech Stack
- PySpark (RDD)
- Python
- Docker

## Dataset
Employee CSV file with schema:
id, name, department, salary

Example:
1,Amit,IT,55000
2,Rahul,HR,40000
3,Neha,IT,65000
4,Priya,Finance,70000
5,Karan,IT,50000
6,Simran,HR,45000
7,Rohit,Finance,60000

## Features
- Sort employees by salary (descending)
- Calculate total salary per department
- Identify top 3 highest-paid employees
- Save output using Spark `saveAsTextFile`

## Project Structure
```
.
├── Dockerfile
├── employee.csv
├── requirements.txt
└── app/
    └── spark_app.py
```

## How to Run

### 1. Build Docker Image
```bash
docker build -t spark-final .
```

### 2. Run Container
```bash
docker run -it spark-final bash
```

### 3. Execute Spark App
```bash
python app/spark_app.py
```

## Output Location
After execution, output is saved here:
```
/workspace/output/top_3_employees
```

To view results:
```bash
cat output/top_3_employees/part-*
```

## Notes
- Spark writes output as multiple part files
- `_SUCCESS` means job completed successfully

## Author
Tanu Shree Soni
