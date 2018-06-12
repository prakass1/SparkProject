
# coding: utf-8

# In[7]:


import pyspark as ps
from pyspark.sql import SparkSession
import sys


# In[9]:


def main():
    if len(sys.argv) != 2:
        print("Usage: wordcount <file>", file=sys.stderr)
        sys.exit(-1)
    
    spark = SparkSession.builder.appName("PySpark_WordCount").getOrCreate()

    lines = spark.read.text(sys.argv[1]).rdd.map(lambda r: r[0])
    counts = lines.flatMap(lambda x: x.split(' '))                   .map(lambda x: (x, 1))                   .reduceByKey(add)
    output = counts.collect()
    for (word, count) in output:
        print("%s: %i" % (word, count))

    spark.stop()


# In[10]:


main()

