from pyspark import pipelines as dp

# -------------------------
# Bronze streaming tables
# -------------------------

@dp.table(name="bronze_daily_stock")
def bronze_daily_stock():
    return spark.readStream.table("bronze_src.daily_stock_incoming")


@dp.table(name="bronze_quotes")
def bronze_quotes():
    return spark.readStream.table("bronze_src.quotes_incoming")


@dp.table(name="bronze_company_info")
def bronze_company_info():
    return spark.readStream.table("bronze_src.company_info_incoming")