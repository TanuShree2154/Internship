import sys
from datetime import datetime


print("Python Version")
print(sys.version)
print()

print("Current Date & Time")
print(datetime.now().strftime("%d-%m-%Y %H:%M:%S"))
