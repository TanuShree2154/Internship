# Dockerized Python Version Application

## Overview

This project demonstrates a simple Dockerized Python application using the official **python:3.12-slim** Docker image.

The application prints:

- Current Python version
- Current date and time

---

## Project Structure

```
python-version-app/
│── app.py
│── Dockerfile
└── README.md
```

---

## Base Image

```
python:3.12-slim
```

---

## Build Docker Image

```bash
docker build -t python-version-app .
```

---

## Run Docker Container

```bash
docker run --rm python-version-app
```

---

## Sample Output

```

Python Version
3.12.x (main, ...)
[GCC ...]

Current Date & Time
23-06-2026 19:45:12

```

---

## Technologies Used

- Python 3.12
- Docker

---

## Author

Tanu Shree Soni
