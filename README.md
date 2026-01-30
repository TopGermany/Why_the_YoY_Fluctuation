# Why Did Revenue Grow Rapidly and Then Decline in a Healthy Drinks Retail Chain in Da Nang?

**Healthy Drinks & Detox Retail Chain – Da Nang**

---

## 1. Business Context

### Business Model  
Healthy Drinks & Detox retail chain operating in Da Nang.

### Company Overview  
The business specializes in detox juices and nutritional beverages, targeting health-conscious local residents and tourists in Da Nang. After three years of operation and expansion, the company has established a relatively stable customer base. Given Da Nang’s characteristics as a major tourist city, sales data exhibits strong seasonality and reflects noticeable changes in consumer behavior across different years.

### Current Business Challenge  
After reaching the three-year milestone, the company has accumulated a large volume of historical data that has not yet been fully utilized. Management requires in-depth analytical reports to reassess growth performance, understand differences across customer segments, and optimize an increasingly complex product menu that has expanded through multiple product launches.

### Project Objectives  
This project applies SQL to query and analyze three years of historical data with the following goals:

- Evaluate long-term revenue trends and assess the impact of seasonality, particularly the tourism season in Da Nang.
- Optimize the product portfolio by identifying long-performing hero products and underperforming items that should be replaced.
- Gain deeper customer insights by classifying customers based on loyalty levels to design appropriate retention strategies.
- Support strategic decision-making by providing data-driven insights for business expansion or operational adjustments.

---

## 2. Data Structure

The database contains **259,527 rows** and **13 columns**, capturing detailed transactional and customer-related information used for analytical purposes.

<img width="945" height="108" alt="image" src="https://github.com/user-attachments/assets/0d53981c-00fe-4c38-8a3d-45d4e31bd2b6" />


---

## 3. Business Performance Overview

During the 2022–2024 period, the business experienced significant fluctuations in revenue, sales volume, and Average Order Value (AOV), reflecting changes in both business scale and customer behavior.

### Revenue Performance
- In 2023, revenue grew strongly, reaching approximately 59.3 billion VND, representing a growth of around 23.5% compared to 2022.
- In 2024, revenue declined to approximately 41.8 billion VND, corresponding to a decrease of about 29.5% year-over-year.
```sql
WITH CTE_1 AS (
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, SUM([Thành tiền]) AS Revenue FROM Sales
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn])
)
SELECT *,(Revenue - Revenue_Previous) * 100.0 / Revenue_Previous AS Growth_Percentage FROM
(SELECT *,LAG(Revenue) OVER(ORDER BY Year) AS Revenue_Previous FROM CTE_1) AS Year_1
```

<img width="410" height="77" alt="image" src="https://github.com/user-attachments/assets/a1068d78-9b8c-4164-a0c3-7c6bd93beda1" />



This pattern indicates a phase of rapid but unsustainable growth, followed by a notable decline in the most recent year.

### Sales Quantity
- Sales volume increased from 31,579 units in 2022 to 43,462 units in 2023, indicating expanding market demand.
- In 2024, sales volume dropped to 34,545 units, reflecting a slowdown in purchasing power or changes in sales strategy.
```sql
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, SUM([Thành tiền]) AS Revenue, COUNT(DISTINCT([Mã Đơn Hàng])) AS Quantity FROM Sales
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn])
ORDER BY YEAR ASC
```

<img width="227" height="72" alt="image" src="https://github.com/user-attachments/assets/8e2539ed-47fe-4b98-b790-33f820dd7c96" />


### Average Order Value (AOV)
- AOV was relatively high in 2022 (approximately 152,008 VND), but declined significantly in 2023 (−10.26%) and continued to decrease in 2024 (−11.33%).
- Despite revenue growth in 2023, the declining AOV indicates that growth was driven primarily by higher order volume rather than higher value per order.
```sql
WITH CTE_1 AS (
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year,SUM([Thành tiền])/COUNT(DISTINCT([Mã đơn hàng])) AS AOV FROM Sales
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn])
)
SELECT *,(AOV - AOV_Previous) * 100.0 / AOV_Previous AS Growth_Percentage FROM 
(SELECT *,LAG(AOV) OVER(ORDER BY Year) AS AOV_Previous FROM CTE_1) AS Year_1
```

<img width="456" height="77" alt="image" src="https://github.com/user-attachments/assets/2e567e22-9bc8-4140-81d6-378dacc82b8a" />


This suggests potential factors such as increased discounting, a shift toward price-sensitive customers, or a higher proportion of lower-priced products.

---

## Monthly Revenue Performance

### 2022 to 2023 Growth Phase
- Most months in 2023 recorded higher revenue compared to 2022.
- Strong growth was observed in January, February, and March, indicating positive momentum at the beginning of the year.
- Revenue peaks in August, October, and December reflect seasonality and year-end demand.
- Revenue growth was accompanied by higher sales volume, suggesting scale-driven expansion.

Overall, 2023 represents a period of comprehensive growth supported by favorable market conditions and effective sales strategies.

### 2023 to 2024 Decline Phase
- The majority of months in 2024 showed revenue declines compared to 2023.
- Significant drops occurred in January, February, and March, indicating an early loss of growth momentum.
- Mid-year months (April to July) continued to weaken, suggesting a prolonged downturn rather than a temporary fluctuation.
- Although some months showed relative stability, the recovery was insufficient to offset the overall decline.

This pattern points to structural challenges, potentially driven by reduced market demand, increased competition, or misaligned pricing and product strategies.

---

## Quarterly Revenue Performance

### 2022 to 2023
- All quarters in 2023 recorded revenue growth compared to 2022.
- Q4 2023 achieved the highest revenue, confirming the importance of year-end seasonality.
- Balanced growth across quarters indicates stable operational performance throughout the year.

### 2023 to 2024
- All four quarters in 2024 experienced revenue declines compared to 2023.
- Q1 and Q4 showed the most severe drops.
- The consistent decline across all quarters suggests a long-term downward trend rather than short-term volatility.

---

## Revenue Decline Analysis – Customer & Order Value Perspective

### Customer Structure Analysis (RFM Segmentation)

RFM analysis reveals significant shifts in customer quality and behavior, particularly in 2024:

- **VIP Customers**  
  Increased significantly from 2022 to 2023, then declined in 2024, indicating ineffective retention of the highest-value customers.

- **Loyal Customers**  
  Peaked in 2023 and dropped sharply in 2024. The loss of this segment has a direct and substantial impact on revenue due to high purchase frequency and AOV.

- **Regular and Potential Loyalists**  
  Showed slow growth or slight decline in 2024, indicating weak conversion into loyal segments.

- **At-Risk and Lost Customers**  
  Increased sharply from 2022 to 2023 and remained high in 2024, reflecting customer churn and reduced purchase frequency.

Overall, revenue decline is driven not only by lower sales volume but primarily by deterioration in customer quality, especially the loss of loyal and VIP customers.

### Continuous AOV Decline
- AOV decreased consistently:
  - Approximately 10% from 2022 to 2023
  - Approximately 11% from 2023 to 2024

This indicates reduced spending per order or a shift toward lower-priced products. Even during the 2023 growth phase, revenue growth was volume-driven rather than value-driven, signaling unsustainable growth.

---

## Linking RFM and AOV – Root Causes of Revenue Decline

Combining customer segmentation and order value analysis reveals:
- Declining high-value customer segments
- Growing at-risk and lost customer segments
- Persistent decline in AOV

These factors collectively lead to declining monthly and quarterly revenue and weak recovery even during peak seasons.

---

## Business Conclusion

The revenue decline in 2024 is not merely a seasonal or short-term market issue. It reflects deeper structural challenges, including ineffective customer retention, decreasing customer value, and a growth strategy overly focused on order volume rather than order quality.

---

## Business Strategy & Data-Driven Recommendations

### Product & Cross-Selling Strategy (Market Basket Analysis)

Market basket analysis identifies frequently co-purchased product pairs such as:
- Celery powder and ginger tea
- Celery powder and dried orange slices or peach tea
- Brown rice tea and ginger tea or fruit tea
- Orange–lemongrass–cinnamon tea and ginger tea

These patterns reflect health-oriented combo purchasing behavior.

Recommended actions include creating fixed product bundles, applying bundle pricing, and implementing cross-sell suggestions at checkout or POS systems. Priority should be given to Regular, Potential Loyalist, and At-Risk customer segments to increase AOV and stimulate repeat purchases.

### Seasonal & Monthly AOV Strategy

Higher AOV is concentrated in June, July, August, and November, while lower AOV occurs in February, March, and April.

During high-AOV months, businesses should push premium upselling and limited-edition products. During low-AOV months, promotional bundles, vouchers, and volume-based discounts can help stabilize revenue and cash flow.

### Operational & Staffing Strategy by Time Slot

Evening shifts (18:00–23:00) generate the highest order volume and total revenue. Morning and afternoon shifts show stable performance with relatively high AOV, while off-peak hours contribute minimally.

Operational optimization should include increased staffing, inventory, and customer service support during evening hours, along with time-based promotions such as flash sales and evening livestream selling.

### RFM-Based Customer Strategy

| Customer Segment | Recommended Strategy |
|------------------|---------------------|
| VIP              | Exclusive offers, premium bundles, early access |
| Loyal            | Loyalty points, subscriptions, scheduled promotions |
| Potential Loyalist | Cross-sell bundles and return incentives |
| Regular          | Light cross-selling and related product recommendations |
| At Risk          | Time-limited discounts and value bundles |
| Lost Customers   | Win-back campaigns via email or SMS |

The primary objective is to increase Customer Lifetime Value rather than focusing solely on order volume.

---

## Strategic Summary

Revenue decline in 2024 is primarily driven by declining AOV, loss of loyal customers, and underutilized cross-selling and timing strategies. Integrating Market Basket Analysis, Time-Based Analysis, and RFM Segmentation enables a data-driven growth strategy focused on improving order quality and long-term customer value.
