from pyspark.sql import SparkSession
from pyspark.sql.functions import col

spark = SparkSession.builder.appName("SalesAnalysis").getOrCreate()


df = spark.read.option("header", True).csv("/workspace/employee.csv", inferSchema=True)
# 1. Sort products by sales (descending)
sorted_df = df.orderBy(col("sales").desc())
print("Sorted Products by Sales ")
sorted_df.show()

# 2. Top 3 products
print("Top 3 Products ")
df.orderBy(col("sales").desc()).show(3)

# 3. Filter sales > 80000
filtered_df = df.filter(col("sales") > 80000)


filtered_df.write.mode("overwrite").csv("/workspace/output/filtered_sales", header=True)
print("Filtered data saved successfully!")

spark.stop()