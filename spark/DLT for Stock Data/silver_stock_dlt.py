from pyspark import pipelines as dp
from pyspark.sql.functions import col, row_number, to_date
from pyspark.sql.window import Window

# -------------------------
# Silver validation rules
# -------------------------

COMMON_SILVER_RULES = {
    "symbol_not_null": "symbol IS NOT NULL",
    "trading_date_not_null": "trading_date IS NOT NULL",
    "open_price_not_null": "open_price IS NOT NULL",
    "high_price_not_null": "high_price IS NOT NULL",
    "low_price_not_null": "low_price IS NOT NULL",
    "close_price_not_null": "close_price IS NOT NULL",
    "volume_not_null": "volume IS NOT NULL",
    "api_pull_ts_not_null": "api_pull_ts IS NOT NULL",
    "high_ge_low": "CAST(high_price AS DOUBLE) >= CAST(low_price AS DOUBLE)",
    "open_ge_low": "CAST(open_price AS DOUBLE) >= CAST(low_price AS DOUBLE)",
    "open_le_high": "CAST(open_price AS DOUBLE) <= CAST(high_price AS DOUBLE)",
    "close_ge_low": "CAST(close_price AS DOUBLE) >= CAST(low_price AS DOUBLE)",
    "close_le_high": "CAST(close_price AS DOUBLE) <= CAST(high_price AS DOUBLE)",
    "volume_non_negative": "CAST(volume AS BIGINT) >= 0"
}

# -------------------------
# Helper function
# -------------------------

def build_silver_table(bronze_table_name):
    bronze_df = spark.read.table(bronze_table_name)

    window_spec = Window.partitionBy("symbol", "trading_date").orderBy(col("api_pull_ts").desc())

    return (
        bronze_df
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
        .withColumn("rn", row_number().over(window_spec))
        .filter(col("rn") == 1)
        .drop("rn")
        .select(
            "symbol",
            "trading_date",
            "open_price",
            "high_price",
            "low_price",
            "close_price",
            "volume",
            "source_last_refreshed",
            "source_timezone",
            "api_pull_ts"
        )
    )

# -------------------------
# Silver tables
# -------------------------

@dp.materialized_view(name="silver_aapl")
@dp.expect_all_or_drop(COMMON_SILVER_RULES)
def silver_aapl():
    return build_silver_table("bronze_aapl_daily")


@dp.materialized_view(name="silver_msft")
@dp.expect_all_or_drop(COMMON_SILVER_RULES)
def silver_msft():
    return build_silver_table("bronze_msft_daily")


@dp.materialized_view(name="silver_googl")
@dp.expect_all_or_drop(COMMON_SILVER_RULES)
def silver_googl():
    return build_silver_table("bronze_googl_daily")


@dp.materialized_view(name="silver_tsla")
@dp.expect_all_or_drop(COMMON_SILVER_RULES)
def silver_tsla():
    return build_silver_table("bronze_tsla_daily")