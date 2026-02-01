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

## Growth Phase: 2022 – 2023
```sql 
WITH CTE_2022 AS (
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, DATEPART(MONTH,[Thời gian tạo đơn]) AS Month,SUM([Thành tiền]) AS Revenue,SUM([Thành tiền])/COUNT(DISTINCT([Mã đơn hàng])) AS AOV,
SUM(SL) AS Quantity FROM Sales
WHERE DATEPART(YEAR,[Thời gian tạo đơn]) = 2022
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn]), DATEPART(MONTH,[Thời gian tạo đơn])
),
CTE_2023 AS (
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, DATEPART(MONTH,[Thời gian tạo đơn]) AS Month,SUM([Thành tiền]) AS Revenue,SUM([Thành tiền])/COUNT(DISTINCT([Mã đơn hàng])) AS AOV,
SUM(SL) AS Quantity FROM Sales
WHERE DATEPART(YEAR,[Thời gian tạo đơn]) = 2023
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn]), DATEPART(MONTH,[Thời gian tạo đơn])
),
CTE_2024 AS (
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, DATEPART(MONTH,[Thời gian tạo đơn]) AS Month,SUM([Thành tiền]) AS Revenue,SUM([Thành tiền])/COUNT(DISTINCT([Mã đơn hàng])) AS AOV,
SUM(SL) AS Quantity FROM Sales
WHERE DATEPART(YEAR,[Thời gian tạo đơn]) = 2024
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn]), DATEPART(MONTH,[Thời gian tạo đơn])
)
SELECT *,(A2023.Revenue - A2022.Revenue) AS Revenue_Growth_2022_2023,(A2024.Revenue - A2023.Revenue) AS Revenue_Growth_2023_2024 FROM CTE_2022 AS A2022
	INNER JOIN CTE_2023 AS A2023
ON A2022.Month = A2023.Month
	INNER JOIN CTE_2024 AS A2024
ON A2023.Month = A2024.Month
ORDER BY A2022.Year, A2022.Month ASC;
```
<img width="1470" height="258" alt="image" src="https://github.com/user-attachments/assets/fe5b3b71-35ce-4a29-9435-3d98886fd452" />


- Most months in **2023** recorded **higher revenue compared to 2022**, indicating a strong growth trend for the business.  
Significant growth was observed in **January, February, and March**, demonstrating positive momentum at the beginning of the year.

- Revenue peaked in **August, October, and December**, reflecting clear **seasonality effects** and increased demand during year-end peak periods.

- However, when analyzing **Average Order Value (AOV)**, it becomes evident that **AOV did not grow proportionally with revenue**, and even declined slightly in several months. This indicates that revenue growth during this period was **primarily driven by higher sales volume**, rather than increased value per transaction.

- Overall, **2023 represents a scale-driven growth phase**, supported by favorable market conditions and effective sales execution, but **lacks long-term sustainability due to the absence of AOV improvement**.

---

## Decline Phase: 2023 – 2024

- Most months in **2024** experienced **a decline in revenue compared to 2023**, marking a clear reversal in the growth trajectory.

- Significant drops occurred as early as **January, February, and March**, indicating that growth momentum was **not sustained**. At the same time, **AOV declined during these early months**, suggesting that customers were **spending less per order**.

- The mid-year period (**April to July**) continued to show **prolonged weakness**, with both **revenue and AOV remaining at low levels**. This pattern suggests that the decline is **structural rather than a short-term seasonal fluctuation**.

- Although some months showed relative stabilization, **AOV failed to recover meaningfully**, preventing revenue from offsetting the decline in order volume.

- Overall, this trend highlights **fundamental challenges** faced by the business, potentially driven by **weaker market demand, increased competition, or misaligned pricing and product strategies**, resulting in a simultaneous decline in both **order quantity and order value**.


---

## Quarterly Revenue Performance
```sql
WITH CTE_2022 AS (
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, DATEPART(QUARTER,[Thời gian tạo đơn]) AS Quater,SUM([Thành tiền]) AS Revenue,SUM(SL) AS Quantity FROM Sales
WHERE DATEPART(YEAR,[Thời gian tạo đơn]) = 2022
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn]), DATEPART(QUARTER,[Thời gian tạo đơn])
),
CTE_2023 AS (
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, DATEPART(QUARTER,[Thời gian tạo đơn]) AS Quater,SUM([Thành tiền]) AS Revenue,SUM(SL) AS Quantity FROM Sales
WHERE DATEPART(YEAR,[Thời gian tạo đơn]) = 2023
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn]), DATEPART(QUARTER,[Thời gian tạo đơn])
),
CTE_2024 AS (
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, DATEPART(QUARTER,[Thời gian tạo đơn]) AS Quater,SUM([Thành tiền]) AS Revenue,SUM(SL) AS Quantity FROM Sales
WHERE DATEPART(YEAR,[Thời gian tạo đơn]) = 2024
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn]), DATEPART(QUARTER,[Thời gian tạo đơn])
)
SELECT *,(A2023.Revenue - A2022.Revenue) AS Revenue_Growth_2022_2023,(A2024.Revenue - A2023.Revenue) AS Revenue_Growth_2023_2024 FROM CTE_2022 AS A2022
	INNER JOIN CTE_2023 AS A2023
ON A2022.Quater = A2023.Quater
	INNER JOIN CTE_2024 AS A2024
ON A2023.Quater = A2024.Quater
ORDER BY A2022.Year, A2022.Quater ASC;

```
<img width="1125" height="102" alt="image" src="https://github.com/user-attachments/assets/c45616dc-c2a4-4067-80a0-ca8006a1123f" />


### Q4 as the Traditional Peak Season
In **2022**, **Q4 was the strongest quarter**, generating the highest revenue (over **1.9 billion**), confirming its role as the traditional peak season.

However, in both **2023 and 2024**, the dominance of Q4 **was not sustained**. The weakening performance in this critical quarter suggests that:
- Market demand during year-end periods has softened, or
- The business has become less effective in capitalizing on peak-season opportunities.

This shift highlights a **decline in end-of-year sales effectiveness**, which has a significant impact on overall annual performance.

---

### Relationship Between Revenue and Sales Volume
Revenue trends closely mirror changes in **sales quantity**, indicating a strong positive correlation between the two.

This suggests that:
- **Average selling prices remained relatively stable**
- Revenue decline was driven primarily by **lower sales volume**, rather than aggressive price reductions or discounting strategies

In other words, the core issue lies in **reduced purchasing activity**, not pricing erosion.

---

## Key Takeaway
The business is facing a **demand-driven revenue decline**, compounded by an inability to fully leverage seasonal peaks—particularly in Q4. Without intervention, this pattern poses a significant risk to long-term revenue sustainability.

---

## Revenue Decline Analysis – Customer & Order Value Perspective

### Customer Structure Analysis (RFM Segmentation)
```SQL
WITH RFM_Martrics2022 AS (
	SELECT [Mã khách hàng],MAX([Thời gian tạo đơn]) AS Last_active_Day, DATEDIFF(DAY,MAX([Thời gian tạo đơn]),'2022-12-31') AS Recency,
	COUNT(DISTINCT([Mã đơn hàng])) AS Frequency, SUM([Thành tiền]) AS Monetary 
	FROM Sales
	WHERE DATEPART(YEAR,[Thời gian tạo đơn]) = 2022
	GROUP BY [Mã khách hàng]
),
RFM_Group2022 AS (
	SELECT *, 
	NTILE(4) OVER (ORDER BY Recency ASC) AS R_Group, 
	NTILE(4) OVER (ORDER BY Frequency DESC) AS F_Group,
	NTILE(4) OVER (ORDER BY Monetary DESC) AS M_Group
	FROM RFM_Martrics2022
),
RFM_Rank2022 AS (
	SELECT 
	[Mã khách hàng],Recency, Frequency,Monetary,
	Case
		WHEN R_Group = 1 THEN 4
		WHEN R_Group = 2 THEN 3
		WHEN R_Group = 3 THEN 2
		WHEN R_Group = 4 THEN 1
	END AS R_Rank
	,
	CASE 
		WHEN F_Group = 1 THEN 4
		WHEN F_Group = 2 THEN 3
		WHEN F_Group = 3 THEN 2
		WHEN F_Group = 4 THEN 1
	END AS F_Rank
	,
	CASE
		WHEN M_Group = 1 THEN 4
		WHEN M_Group = 2 THEN 3
		WHEN M_Group = 3 THEN 2
		WHEN M_Group = 4 THEN 1
	END AS M_Rank
	FROM RFM_Group2022
),
Name_Segment_2022 AS (
	SELECT *, CONCAT(R_Rank,F_Rank,M_Rank) AS PKKH, 
		CASE 
				WHEN R_Rank = 4 AND F_Rank = 4 AND M_Rank = 4 THEN N'VIP'
				WHEN R_Rank >= 3 AND F_Rank >= 3 AND M_Rank >= 3 THEN N'Loyal Customers'
				WHEN R_Rank >= 3 AND F_Rank >= 2 THEN N'Potential Loyalist'
				WHEN R_Rank <= 2 AND F_Rank >= 3 THEN N'At Risk'
				WHEN R_Rank = 1 AND F_Rank = 1 THEN N'Lost Customers'
				ELSE N'Regular'
			END AS customer_segment
	FROM RFM_Rank2022
),
Segment_2022 AS (
	SELECT customer_segment,COUNT(*) AS Total_SegmentCustomer2022 
	FROM Name_Segment_2022
	GROUP BY customer_segment
),
RFM_Martrics2023 AS (
	SELECT [Mã khách hàng],MAX([Thời gian tạo đơn]) AS Last_active_Day, DATEDIFF(DAY,MAX([Thời gian tạo đơn]),'2023-12-31') AS Recency,
	COUNT(DISTINCT([Mã đơn hàng])) AS Frequency, SUM([Thành tiền]) AS Monetary 
	FROM Sales
	WHERE DATEPART(YEAR,[Thời gian tạo đơn]) = 2023
	GROUP BY [Mã khách hàng]
),
RFM_Group2023 AS (
	SELECT *, 
	NTILE(4) OVER (ORDER BY Recency ASC) AS R_Group, 
	NTILE(4) OVER (ORDER BY Frequency DESC) AS F_Group,
	NTILE(4) OVER (ORDER BY Monetary DESC) AS M_Group
	FROM RFM_Martrics2023
),
RFM_Rank2023 AS (
	SELECT 
	[Mã khách hàng],Recency, Frequency,Monetary,
	Case
		WHEN R_Group = 1 THEN 4
		WHEN R_Group = 2 THEN 3
		WHEN R_Group = 3 THEN 2
		WHEN R_Group = 4 THEN 1
	END AS R_Rank
	,
	CASE 
		WHEN F_Group = 1 THEN 4
		WHEN F_Group = 2 THEN 3
		WHEN F_Group = 3 THEN 2
		WHEN F_Group = 4 THEN 1
	END AS F_Rank
	,
	CASE
		WHEN M_Group = 1 THEN 4
		WHEN M_Group = 2 THEN 3
		WHEN M_Group = 3 THEN 2
		WHEN M_Group = 4 THEN 1
	END AS M_Rank
	FROM RFM_Group2023
),
Name_Segment_2023 AS (
	SELECT *, CONCAT(R_Rank,F_Rank,M_Rank) AS PKKH, 
		CASE 
				WHEN R_Rank = 4 AND F_Rank = 4 AND M_Rank = 4 THEN N'VIP'
				WHEN R_Rank >= 3 AND F_Rank >= 3 AND M_Rank >= 3 THEN N'Loyal Customers'
				WHEN R_Rank >= 3 AND F_Rank >= 2 THEN N'Potential Loyalist'
				WHEN R_Rank <= 2 AND F_Rank >= 3 THEN N'At Risk'
				WHEN R_Rank = 1 AND F_Rank = 1 THEN N'Lost Customers'
				ELSE N'Regular'
			END AS customer_segment
	FROM RFM_Rank2023
),
Segment_2023 AS (
	SELECT customer_segment,COUNT(*) AS Total_SegmentCustomer2023 
	FROM Name_Segment_2023
	GROUP BY customer_segment
),
RFM_Martrics2024 AS (
	SELECT [Mã khách hàng],MAX([Thời gian tạo đơn]) AS Last_active_Day, DATEDIFF(DAY,MAX([Thời gian tạo đơn]),'2024-12-31') AS Recency,
	COUNT(DISTINCT([Mã đơn hàng])) AS Frequency, SUM([Thành tiền]) AS Monetary 
	FROM Sales
	WHERE DATEPART(YEAR,[Thời gian tạo đơn]) = 2024
	GROUP BY [Mã khách hàng]
),
RFM_Group2024 AS (
	SELECT *, 
	NTILE(4) OVER (ORDER BY Recency ASC) AS R_Group, 
	NTILE(4) OVER (ORDER BY Frequency DESC) AS F_Group,
	NTILE(4) OVER (ORDER BY Monetary DESC) AS M_Group
	FROM RFM_Martrics2024
),
RFM_Rank2024 AS (
	SELECT 
	[Mã khách hàng],Recency, Frequency,Monetary,
	Case
		WHEN R_Group = 1 THEN 4
		WHEN R_Group = 2 THEN 3
		WHEN R_Group = 3 THEN 2
		WHEN R_Group = 4 THEN 1
	END AS R_Rank
	,
	CASE 
		WHEN F_Group = 1 THEN 4
		WHEN F_Group = 2 THEN 3
		WHEN F_Group = 3 THEN 2
		WHEN F_Group = 4 THEN 1
	END AS F_Rank
	,
	CASE
		WHEN M_Group = 1 THEN 4
		WHEN M_Group = 2 THEN 3
		WHEN M_Group = 3 THEN 2
		WHEN M_Group = 4 THEN 1
	END AS M_Rank
	FROM RFM_Group2024
),
Name_Segment_2024 AS (
	SELECT *, CONCAT(R_Rank,F_Rank,M_Rank) AS PKKH, 
		CASE 
				WHEN R_Rank = 4 AND F_Rank = 4 AND M_Rank = 4 THEN N'VIP'
				WHEN R_Rank >= 3 AND F_Rank >= 3 AND M_Rank >= 3 THEN N'Loyal Customers'
				WHEN R_Rank >= 3 AND F_Rank >= 2 THEN N'Potential Loyalist'
				WHEN R_Rank <= 2 AND F_Rank >= 3 THEN N'At Risk'
				WHEN R_Rank = 1 AND F_Rank = 1 THEN N'Lost Customers'
				ELSE N'Regular'
			END AS customer_segment
	FROM RFM_Rank2024
),
Segment_2024 AS (
	SELECT customer_segment,COUNT(*) AS Total_SegmentCustomer2024 
	FROM Name_Segment_2024
	GROUP BY customer_segment
)
SELECT * FROM Segment_2022 AS S2
	INNER JOIN Segment_2023 AS S3
ON S2.customer_segment = S3.customer_segment
	INNER JOIN Segment_2024 AS S4
ON S4.customer_segment = S3.customer_segment
ORDER BY S2.customer_segment DESC
```
<img width="950" height="142" alt="image" src="https://github.com/user-attachments/assets/bcd5760d-9baf-4ee5-9a7b-bf764246b31b" />


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

<img width="457" height="77" alt="image" src="https://github.com/user-attachments/assets/8c2799b3-dfe3-4299-b0d2-a15aba107344" />

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
```SQL
SELECT TOP 10 A.[Tên mặt hàng],B.[Tên mặt hàng],COUNT(*) AS Frequency FROM 
Sales AS A JOIN Sales AS B ON A.[Mã đơn hàng] = B.[Mã đơn hàng] AND A.[Mã mặt hàng] < B.[Mã mặt hàng]
GROUP BY A.[Tên mặt hàng],B.[Tên mặt hàng]
ORDER BY COUNT(*) DESC;
```

<img width="326" height="215" alt="image" src="https://github.com/user-attachments/assets/b548320c-054b-4bf8-a70f-2b2fd03baaa8" />


Market basket analysis identifies frequently co-purchased product pairs such as:
- Celery powder and ginger tea
- Celery powder and dried orange slices or peach tea
- Brown rice tea and ginger tea or fruit tea
- Orange–lemongrass–cinnamon tea and ginger tea

These patterns reflect health-oriented combo purchasing behavior.

Recommended actions include creating fixed product bundles, applying bundle pricing, and implementing cross-sell suggestions at checkout or POS systems. Priority should be given to Regular, Potential Loyalist, and At-Risk customer segments to increase AOV and stimulate repeat purchases.

### Seasonal & Monthly AOV Strategy
```SQL
SELECT CONCAT('Tháng ',MONTH([Thời gian tạo đơn])) AS Month, SUM([Thành tiền])/COUNT(distinct[Mã đơn hàng]) AS AOV FROM Sales
GROUP BY MONTH([Thời gian tạo đơn]) 
ORDER BY AOV DESC;

```

<img width="227" height="260" alt="image" src="https://github.com/user-attachments/assets/57215bcb-bdf4-4ad5-8539-f80deaf2c0ad" />


Higher AOV is concentrated in June, July, August, and November, while lower AOV occurs in February, March, and April.

During high-AOV months, businesses should push premium upselling and limited-edition products. During low-AOV months, promotional bundles, vouchers, and volume-based discounts can help stabilize revenue and cash flow.

### Operational & Staffing Strategy by Time Slot
```SQL
SELECT 
    CASE 
        WHEN DATEPART(HOUR, [Thời gian tạo đơn]) >= 8 AND DATEPART(HOUR, [Thời gian tạo đơn]) < 13 THEN N'Ca Sáng (8h-13h)'
        WHEN DATEPART(HOUR, [Thời gian tạo đơn]) >= 13 AND DATEPART(HOUR, [Thời gian tạo đơn]) < 18 THEN N'Ca Chiều (13h-18h)'
        WHEN DATEPART(HOUR, [Thời gian tạo đơn]) >= 18 AND DATEPART(HOUR, [Thời gian tạo đơn]) < 23 THEN N'Ca Tối (18h-23h)'
        ELSE N'Ngoài giờ hành chính'
    END AS [Ca Làm Việc],
    COUNT(DISTINCT [Mã đơn hàng]) AS [Số Đơn Hàng],
    SUM([Thành tiền]) AS [Tổng Doanh Thu],
    SUM([Thành tiền]) / COUNT(DISTINCT [Mã đơn hàng]) AS AOV
FROM Sales
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, [Thời gian tạo đơn]) >= 8 AND DATEPART(HOUR, [Thời gian tạo đơn]) < 13 THEN N'Ca Sáng (8h-13h)'
        WHEN DATEPART(HOUR, [Thời gian tạo đơn]) >= 13 AND DATEPART(HOUR, [Thời gian tạo đơn]) < 18 THEN N'Ca Chiều (13h-18h)'
        WHEN DATEPART(HOUR, [Thời gian tạo đơn]) >= 18 AND DATEPART(HOUR, [Thời gian tạo đơn]) < 23 THEN N'Ca Tối (18h-23h)'
        ELSE N'Ngoài giờ hành chính'
    END
ORDER BY AOV DESC;
```

<img width="492" height="98" alt="image" src="https://github.com/user-attachments/assets/7f5422b6-289f-47cb-b1fe-c197804f77fc" />


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
