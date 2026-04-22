from pyspark import pipelines as dp
from pyspark.sql.functions import col, lag, round, when
from pyspark.sql.window import Window

# -------------------------
# Gold stock history
# -------------------------

@dp.materialized_view(name="gold_stock_history")
def gold_stock_history():
    aapl_df = spark.read.table("silver_aapl")
    msft_df = spark.read.table("silver_msft")
    googl_df = spark.read.table("silver_googl")
    tsla_df = spark.read.table("silver_tsla")

    return (
        aapl_df
        .unionByName(msft_df)
        .unionByName(googl_df)
        .unionByName(tsla_df)
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
# Gold price trend
# -------------------------

@dp.materialized_view(name="gold_price_trend")
def gold_price_trend():
    df = spark.read.table("gold_stock_history")

    price_window_spec = Window.partitionBy("symbol").orderBy("trading_date")

    return (
        df
        .withColumn("close_price_7d_ago", lag("close_price", 7).over(price_window_spec))
        .withColumn("close_price_30d_ago", lag("close_price", 30).over(price_window_spec))
        .withColumn("close_price_90d_ago", lag("close_price", 90).over(price_window_spec))
        .withColumn("price_change_7d", col("close_price") - col("close_price_7d_ago"))
        .withColumn("price_change_30d", col("close_price") - col("close_price_30d_ago"))
        .withColumn("price_change_90d", col("close_price") - col("close_price_90d_ago"))
        .withColumn(
            "price_pct_change_7d",
            when(
                col("close_price_7d_ago").isNull() | (col("close_price_7d_ago") == 0),
                None
            ).otherwise(round((col("price_change_7d") / col("close_price_7d_ago")) * 100, 2))
        )
        .withColumn(
            "price_pct_change_30d",
            when(
                col("close_price_30d_ago").isNull() | (col("close_price_30d_ago") == 0),
                None
            ).otherwise(round((col("price_change_30d") / col("close_price_30d_ago")) * 100, 2))
        )
        .withColumn(
            "price_pct_change_90d",
            when(
                col("close_price_90d_ago").isNull() | (col("close_price_90d_ago") == 0),
                None
            ).otherwise(round((col("price_change_90d") / col("close_price_90d_ago")) * 100, 2))
        )
        .select(
            "symbol",
            "trading_date",
            "close_price",
            "close_price_7d_ago",
            "close_price_30d_ago",
            "close_price_90d_ago",
            "price_change_7d",
            "price_change_30d",
            "price_change_90d",
            "price_pct_change_7d",
            "price_pct_change_30d",
            "price_pct_change_90d",
            "volume",
            "api_pull_ts"
        )
    )

# -------------------------
# Gold volume trend
# -------------------------

@dp.materialized_view(name="gold_volume_trend")
def gold_volume_trend():
    df = spark.read.table("gold_stock_history")

    volume_window_spec = Window.partitionBy("symbol").orderBy("trading_date")

    return (
        df
        .withColumn("volume_7d_ago", lag("volume", 7).over(volume_window_spec))
        .withColumn("volume_30d_ago", lag("volume", 30).over(volume_window_spec))
        .withColumn("volume_90d_ago", lag("volume", 90).over(volume_window_spec))
        .withColumn("volume_change_7d", col("volume") - col("volume_7d_ago"))
        .withColumn("volume_change_30d", col("volume") - col("volume_30d_ago"))
        .withColumn("volume_change_90d", col("volume") - col("volume_90d_ago"))
        .select(
            "symbol",
            "trading_date",
            "volume",
            "volume_7d_ago",
            "volume_30d_ago",
            "volume_90d_ago",
            "volume_change_7d",
            "volume_change_30d",
            "volume_change_90d",
            "close_price",
            "api_pull_ts"
        )
    )