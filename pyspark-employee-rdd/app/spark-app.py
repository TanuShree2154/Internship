from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("EmployeeRDD").getOrCreate()
sc= spark.sparkContext

rdd = sc.textFile("employee.csv")
#sort all employees by salary in descending order and display the results on the console
header = rdd.first()

rdd_structured = rdd.filter(lambda x: x.strip() != header.strip()) \
    .filter(lambda x: len(x.split(",")) == 4) \
    .map(lambda x: x.split(",")) \
    .map(lambda x: (int(x[0]), x[1], x[2], int(x[3])))

sorted_employees = rdd_structured.sortBy(lambda x: x[3], ascending=False)

print("Employees sorted by salary ")
print(sorted_employees.collect())

#calculate the total salary paid in each department and print the department-wise totals
dept_salary_rdd = rdd_structured.map(lambda x: (x[2], x[3]))
dept_total_salary = dept_salary_rdd.reduceByKey(lambda a, b: a + b)
print(dept_total_salary.collect())
#identify the top three highest-paid employees and save the output to a file
sorted_rdd = rdd_structured.sortBy(lambda x: x[3], ascending=False)
top_3 = sorted_rdd.take(3)
top_3_rdd = sc.parallelize(top_3)
print(">>> Reached output write step")
top_3_rdd.saveAsTextFile("/workspace/output/top_3_employees")
print(">>> Write completed")