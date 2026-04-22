from pyspark import pipelines as dp
from pyspark.sql.functions import col

# -------------------------
# Bronze daily tables
# -------------------------

@dp.table(name="bronze_aapl_daily")
def bronze_aapl_daily():
    return spark.read.table("raw_stock.alpha_daily_raw").filter(col("symbol") == "AAPL")


@dp.table(name="bronze_msft_daily")
def bronze_msft_daily():
    return spark.read.table("raw_stock.alpha_daily_raw").filter(col("symbol") == "MSFT")


@dp.table(name="bronze_googl_daily")
def bronze_googl_daily():
    return spark.read.table("raw_stock.alpha_daily_raw").filter(col("symbol") == "GOOGL")


@dp.table(name="bronze_tsla_daily")
def bronze_tsla_daily():
    return spark.read.table("raw_stock.alpha_daily_raw").filter(col("symbol") == "TSLA")


# -------------------------
# Bronze quote tables
# -------------------------

@dp.table(name="bronze_aapl_quote")
def bronze_aapl_quote():
    return spark.read.table("raw_stock.alpha_quote_raw").filter(col("symbol") == "AAPL")


@dp.table(name="bronze_msft_quote")
def bronze_msft_quote():
    return spark.read.table("raw_stock.alpha_quote_raw").filter(col("symbol") == "MSFT")


@dp.table(name="bronze_googl_quote")
def bronze_googl_quote():
    return spark.read.table("raw_stock.alpha_quote_raw").filter(col("symbol") == "GOOGL")


@dp.table(name="bronze_tsla_quote")
def bronze_tsla_quote():
    return spark.read.table("raw_stock.alpha_quote_raw").filter(col("symbol") == "TSLA")


# -------------------------
# Bronze company tables
# -------------------------

@dp.table(name="bronze_aapl_company")
def bronze_aapl_company():
    return spark.read.table("raw_stock.alpha_company_raw").filter(col("symbol") == "AAPL")


@dp.table(name="bronze_msft_company")
def bronze_msft_company():
    return spark.read.table("raw_stock.alpha_company_raw").filter(col("symbol") == "MSFT")


@dp.table(name="bronze_googl_company")
def bronze_googl_company():
    return spark.read.table("raw_stock.alpha_company_raw").filter(col("symbol") == "GOOGL")


@dp.table(name="bronze_tsla_company")
def bronze_tsla_company():
    return spark.read.table("raw_stock.alpha_company_raw").filter(col("symbol") == "TSLA")