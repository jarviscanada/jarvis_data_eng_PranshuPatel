from pyspark import pipelines as dp
from pyspark.sql.functions import col, to_date

# -------------------------
# Silver rules for daily stock
# -------------------------

DAILY_STOCK_RULES = {
    "symbol_not_null": "symbol IS NOT NULL",
    "trading_date_not_null": "trading_date IS NOT NULL",
    "open_price_not_null": "open_price IS NOT NULL",
    "high_price_not_null": "high_price IS NOT NULL",
    "low_price_not_null": "low_price IS NOT NULL",
    "close_price_not_null": "close_price IS NOT NULL",
    "volume_not_null": "volume IS NOT NULL",
    "api_pull_ts_not_null": "api_pull_ts IS NOT NULL",
    "high_ge_low": "high_price >= low_price",
    "open_ge_low": "open_price >= low_price",
    "open_le_high": "open_price <= high_price",
    "close_ge_low": "close_price >= low_price",
    "close_le_high": "close_price <= high_price",
    "volume_non_negative": "volume >= 0"
}

# -------------------------
# Silver rules for quotes
# -------------------------

QUOTE_RULES = {
    "symbol_not_null": "symbol IS NOT NULL",
    "price_not_null": "price IS NOT NULL",
    "volume_not_null": "volume IS NOT NULL",
    "latest_trading_day_not_null": "latest_trading_day IS NOT NULL",
    "api_pull_ts_not_null": "api_pull_ts IS NOT NULL",
    "price_positive": "price > 0",
    "volume_non_negative": "volume >= 0"
}

# -------------------------
# Silver rules for company info
# -------------------------

COMPANY_INFO_RULES = {
    "symbol_not_null": "symbol IS NOT NULL",
    "name_not_null": "name IS NOT NULL",
    "exchange_not_null": "exchange IS NOT NULL",
    "api_pull_ts_not_null": "api_pull_ts IS NOT NULL"
}

# -------------------------
# Silver daily stock
# -------------------------

@dp.table(name="silver_daily_stock")
@dp.expect_all_or_drop(DAILY_STOCK_RULES)
def silver_daily_stock():
    return (
        spark.readStream.table("bronze_daily_stock")
        .select(
            col("symbol").cast("string").alias("symbol"),
            to_date(col("trading_date")).alias("trading_date"),
            col("open_price").cast("double").alias("open_price"),
            col("high_price").cast("double").alias("high_price"),
            col("low_price").cast("double").alias("low_price"),
            col("close_price").cast("double").alias("close_price"),
            col("volume").cast("bigint").alias("volume"),
            col("source_last_refreshed").cast("string").alias("source_last_refreshed"),
            col("source_timezone").cast("string").alias("source_timezone"),
            col("api_pull_ts").alias("api_pull_ts")
        )
    )

# -------------------------
# Silver quotes
# -------------------------

@dp.table(name="silver_quotes")
@dp.expect_all_or_drop(QUOTE_RULES)
def silver_quotes():
    return (
        spark.readStream.table("bronze_quotes")
        .select(
            col("symbol").cast("string").alias("symbol"),
            col("price").cast("double").alias("price"),
            col("volume").cast("bigint").alias("volume"),
            to_date(col("latest_trading_day")).alias("latest_trading_day"),
            col("previous_close").cast("double").alias("previous_close"),
            col("change").cast("double").alias("change"),
            col("change_percent").cast("string").alias("change_percent"),
            col("api_pull_ts").alias("api_pull_ts")
        )
    )

# -------------------------
# Silver company info
# -------------------------

@dp.table(name="silver_company_info")
@dp.expect_all_or_drop(COMPANY_INFO_RULES)
def silver_company_info():
    return (
        spark.readStream.table("bronze_company_info")
        .select(
            col("symbol").cast("string").alias("symbol"),
            col("name").cast("string").alias("name"),
            col("exchange").cast("string").alias("exchange"),
            col("sector").cast("string").alias("sector"),
            col("industry").cast("string").alias("industry"),
            col("market_capitalization").cast("string").alias("market_capitalization"),
            col("country").cast("string").alias("country"),
            col("currency").cast("string").alias("currency"),
            col("api_pull_ts").alias("api_pull_ts")
        )
    )