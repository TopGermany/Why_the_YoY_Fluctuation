# Why the YoY Fluctuation ?
1. BUSINESS CONTEXT
Business Model

A healthy drinks & detox retail chain operating in Da Nang, Vietnam, specializing in detox juices and nutritious beverages.

After three years of operation, the business has built a stable customer base consisting of:

Local residents with a healthy lifestyle

Tourists visiting a major tourism city

Due to the nature of the market, sales data shows strong seasonality and clear changes in customer behavior over time.

Business Problem

Although the company owns a large amount of historical sales data, the data has not been fully leveraged to support strategic decision-making.

Management needs:

A comprehensive review of growth performance

A deeper understanding of customer segments

Insights to optimize an increasingly complex product menu

2. PROJECT OBJECTIVES

This project uses SQL to analyze historical sales data from 2022 to 2024 in order to:

Evaluate long-term revenue trends
Analyze revenue by year, month, and quarter to identify seasonality effects.

Optimize product portfolio
Identify core products that consistently perform well and products that underperform.

Understand customer behavior
Segment customers using RFM analysis to assess customer quality and loyalty.

Support business decisions
Provide data-driven insights for growth strategy adjustments.

3. DATA STRUCTURE

The sales database includes:

259,527 rows

15 columns

Full transaction history from 2022–2024

Main data categories:

Transaction time

Order information

Customer information

Product and revenue details

4. BUSINESS PERFORMANCE OVERVIEW
4.1 Revenue Performance

Revenue increased significantly in 2023, reaching approximately 59.3 billion VND (+23.5% YoY).

In 2024, revenue dropped to around 41.8 billion VND (−29.5% YoY).

This indicates rapid but unsustainable growth, followed by a clear downturn in the most recent year.

Suggested illustration:

SQL query result table: total revenue by year

4.2 Sales Quantity

Sales volume increased from 31,579 units in 2022 to 43,462 units in 2023.

In 2024, volume declined to 34,545 units.

This suggests weakening demand or changes in sales strategy.

Suggested illustration:

SQL query result table: total quantity by year

4.3 Average Order Value (AOV)

AOV was highest in 2022 (~152,008 VND).

Decreased by ~10.26% in 2023.

Continued to decline by ~11.33% in 2024.

Even during revenue growth in 2023, growth was driven mainly by order volume rather than order value.

This reflects:

Heavy discounting strategies

Increased price-sensitive customers

Higher share of low-value products

Suggested illustration:

SQL query result table: AOV by year

5. TIME-BASED ANALYSIS
5.1 Monthly Revenue Analysis

From 2022 to 2023:

Most months showed strong growth

Particularly at the beginning and end of the year

From 2023 to 2024:

Revenue declined in most months

The decline started early and persisted throughout the year

This suggests structural challenges rather than short-term seasonality.

Suggested illustration:

SQL query result table: revenue by month and year

5.2 Quarterly Revenue Analysis

All quarters grew in 2023 compared to 2022

All quarters declined in 2024, especially Q1 and Q4

This confirms a long-term downward trend.

Suggested illustration:

SQL query result table: revenue by quarter

6. CUSTOMER ANALYSIS – RFM SEGMENTATION

RFM analysis reveals significant changes in customer quality:

VIP and Loyal customers increased in 2023 but declined sharply in 2024.

At Risk and Lost customers increased and remained high.

Conversion from Potential Loyalists to Loyal customers was weak.

Key insight:
Revenue decline is mainly driven by the loss of high-value customers, not just fewer orders.

Suggested illustration:

SQL result table: RFM customer segmentation

7. ROOT CAUSE ANALYSIS – RFM & AOV

By combining customer and order perspectives:

High-value customers declined

Risky and lost customers increased

AOV continuously decreased

These factors together led to:

Revenue decline by month and quarter

Weak recovery even during peak seasons

8. BUSINESS CONCLUSION

The revenue decline in 2024 reflects:

Ineffective customer retention

Decreasing value per customer

A growth strategy focused on quantity over quality

9. DATA-DRIVEN RECOMMENDATIONS

Focus on retaining VIP and Loyal customers

Increase AOV through bundling and cross-selling

Optimize strategies based on seasonality and time periods

Launch win-back campaigns for At Risk and Lost customers

10. SKILLS DEMONSTRATED

SQL (Aggregation, Window Functions, Time-based Analysis)

RFM Segmentation

Revenue & Business Analysis

Data-driven Decision Making
