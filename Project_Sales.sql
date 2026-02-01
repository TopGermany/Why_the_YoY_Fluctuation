CREATE DATABASE Project_Sales

-- Sử dụng database
USE Project_Sales

-- Xem bảng Sales
SELECT * FROM Sales

/*
Mục tiêu: 
- Tìm hiểu bối cảnh của doanh nghiệp
- Nguyên nhân tăng trưởng doanh thu hoặc suy giảm doanh thu
- Hiểu được tâm lý khách hàng
- Đưa ra các chiến lược, giải pháp tối ưu chi phí, tăng trưởng doanh thu cho cửa hàng trong thời gian tới
- Đánh giá xem các chiến lược, giải pháp có hiệu quả hay không 
*/

-- Phần I: Tìm hiểu bối cảnh của doanh nghiệp

/* Doanh thu của cửa hàng tăng trưởng như thế nào trong 3 năm (2022-2024) ? */

-- Tổng doanh thu của cửa hàng:
SELECT SUM([Thành tiền]) AS Revenue FROM Sales;

-- Doanh thu của cửa hàng theo năm
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, SUM([Thành tiền]) AS Revenue, COUNT(DISTINCT([Mã Đơn Hàng])) AS Quantity FROM Sales
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn])
ORDER BY YEAR ASC

-- Tính phần trăm tăng trưởng doanh thu
WITH CTE_1 AS (
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, SUM([Thành tiền]) AS Revenue FROM Sales
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn])
)
SELECT *,(Revenue - Revenue_Previous) * 100.0 / Revenue_Previous AS Growth_Percentage FROM
(SELECT *,LAG(Revenue) OVER(ORDER BY Year) AS Revenue_Previous FROM CTE_1) AS Year_1

-- Tính phần trăm tăng trưởng AOV
WITH CTE_1 AS (
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year,SUM([Thành tiền])/COUNT(DISTINCT([Mã đơn hàng])) AS AOV FROM Sales
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn])
)
SELECT *,(AOV - AOV_Previous) * 100.0 / AOV_Previous AS Growth_Percentage FROM 
(SELECT *,LAG(AOV) OVER(ORDER BY Year) AS AOV_Previous FROM CTE_1) AS Year_1
/*
Nhận xét:
- Năm 2022: Cửa hàng có tổng doanh thu là 4,800,270,000 tỷ và số lượng bán là 9,2782 sản phẩm đây là một con số doanh thu ấn tượng cho một cửa hàng TMĐT bán các sản phẩm về đồ uống sức khỏe
và đây cũng là mốc thời gian đầu của cửa hàng, qua đó làm bệ phóng cho các năm sau.

- Năm 2023: Đây là năm tăng trưởng doanh thu của cửa hàng từ 4,800,270,000 tỷ và số lượng bán là 11,3548 đến 5,928,696,000 tỷ cho thấy năm 2023 không những tiếp nối doanh thu của năm 
2022 mà còn tăng trưởng. Đây là tính hiệu tích cực cho cửa hàng.

- Năm 2024: Mặc dù năm 2023 là một dấu hiệu tích cực của cửa hàng nhưng năm 2024 lại là một sự giảm sút doanh thu của cửa hàng, doanh thu chỉ đạt 4,178,553,000 
và số lượng sản phẩm bán ra chỉ đạt 8,0145 sản phẩm qua Query truy vấn ta có thể thấy doanh thu của năm 2024 thấp hơn năm 2023 và thậm chí còn thấp hơn năm 2022. 
Qua năm 2024 chúng ta sẽ phải đặt nhiều câu hỏi cho sự giảm sút này của cửa hàng

Câu hỏi đặt ra:
- Đâu là giai đoạn doanh thu của cửa hàng lại giảm sút ? 
- Đâu là yếu tố khiến cho doanh thu của cửa hàng giảm sút ?
*/

-- Doanh thu của cửa hàng theo quý 
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

-- Doanh thu và AOV của cửa hàng theo tháng
CREATE VIEW Doanh_thu_cua_hang_theo_thang AS
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

/*
Nhận xét: 
- Năm 2022: Năm 2022 là cột mốc của cửa hàng, chúng ta có thể thấy doanh thu của cửa hàng tập trung và các quý cuối năm với doanh thu đạt đỉnh điểm khá cao
lần lượt là Q3: 1,326,482,000 tỷ và Q4: 1,934,240,000 tỷ đây là con số ấn tượng cho năm đầu bán hàng và cũng đoán được đôi phần tâm lý khách hàng khi mua sản phẩm
của cửa hàng sẽ tập trung vào các dịp cuối năm. Q1 của cửa hang đạt doanh thu 858,379,000 triệu đây cũng là một con số ấn tượng khi bắt đầu của cửa hàng. Q3 là quý
có doanh thu thấp nhất của cửa hàng đạt 681,169,000 nhưng đây cũng là một con số ổn định.

Năm 2023-2024: Nhìn sơ qua thì chúng ta cũng thấy rằng năm 2023 doanh thu của Q1,Q2,Q3 đạt đỉnh điểm đặc biệt là Q1 qua đó cũng đoán được rằng cửa hàng đã đẩy mạnh các
chiến dịch đầu năm khuyến khích khách hàng mua vào Q1 là quý mà có dịp lễ lớn nhất ở Việt Nam và tiếp nối tăng trưởng ở 2 quý tiếp theo lần lượt là Q2: 999,868,000 triệu
và Q3 = 1,450,299,000 tỷ. Tích cực hơn nữa đó là Q2 tăng trưởng rất nhiều so với năm 2022. Nhưng ở đây Q4 lại có doanh thu thấp hơn rất nhiều so với năm 2022 và
nhìn sâu vào hơn thì chúng ta có thể nhìn thấy đó là bắt đầu T9 năm 2023 kéo dài qua các quý năm 2024 doanh thu của cửa hàng giảm đi rất nhiều và thậm chí doanh thu
của các tháng 2024 không tăng thậm chí còn âm so với 2 năm 2022 và 2023.
*/

-- KẾT LUẬN:
/*
Dựa vào các câu truy lệnh sau ta có thể trả lời cho câu hỏi ta đã đặt ở đầu:
- Bắt đầu giai đoạn nào thì doanh thu của cửa hàng lại giảm sút ?

Trả lời:
- Giai đoạn bước vào Q4 năm 2023 cho đến hết năm 2024 doanh thu của cửa hàng giảm mạnh và đặt ra nhiều câu hỏi cho bản thân mình khi làm về bộ dữ liệu này.

Trả lời:
- Dựa vào những câu truy vấn trên ta có thể chắc chắn rằng các chiến dịch Marketing, Quảng bá của cửa hàng đã ko đạt hiểu quả cao ở cuối năm 2023.
Gợi ý hành động:
- Dựa vào năm 2022, ta có thể thấy Q1 và Q4  là giai đoạn doanh thu tăng cao nhất -> Đẩy mạnh các chiến dịch quảng bá và Marketing vào giai đoạn này vào các năm sau.
- Có các chiến dịch khuyến mãi, chăm sóc khách hàng cho những khách hàng quay lại cửa hàng nhiều
- Tập trung vào các giờ bán hàng cao điểm để LiveStream để thu hút khách hàng
- Sử dụng các chiến dịch Upsell, CrossSell để tăng doanh thu cho cửa hàng 

Lưu ý:
- Ở câu hỏi số 2 hiện tại vẫn chưa trả lời được chúng ta sẽ xuống phần II để hiểu được tâm lý khách hàng để chúng ta có thể làm rõ và trả lời câu hỏi này.
*/

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Phần II: Nguyên nhân tăng trưởng doanh thu hoặc suy giảm doanh thu
/* 
- Mục tiêu chính: Làm thế nào hiểu được Nguyên nhân làm suy giảm doanh thu trong giai đoạn 2023-2024, và một số biến động của các chỉ số trong 3 năm
*/

-- RFM của 3 năm 
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



/*
- Giai đoạn 2022-2923: Đây là giai đoạn giữ chân khách hàng đỉnh điểm của hàng các tệp khách Vip, Regular, Potential Loyalist, Loyal Customer tăng cao cho thấy rằng có chiến dịch 
Marketing giữ chân cửa hàng đã đạt kết quả tốt qua đó tạo doanh thu lớn trong năm 2023

- Giai đoạn 2023-2024: Mặc dù giai đoạn 2023 của các tệp hàng của năm này đóng góp vào sự tăng trưởng doanh thu khá cao nhưng năm 2024 thì lại không được như vậy các tệp khách hàng
Vip, Regular, Potential Loyalist, Loyal Customer giảm đi rất nhiều khiến cho doanh thu của năm 2024 giảm mạnh so với năm 2023. Và đây chính là Nguyên nhân đầu tiên mà ta tìm ra được

- Kết luận 1: Nguyên nhân sự biến động doanh thu của năm 2023-2024 đó là không giữ chân được khách hàng trung thành
*/

-- Chỉ số AOV qua từng năm
SELECT DATEPART(YEAR,[Thời gian tạo đơn]) AS Year, SUM([Thành tiền]) / COUNT(DISTINCT([Mã đơn hàng])) AS AOV FROM Sales
GROUP BY DATEPART(YEAR,[Thời gian tạo đơn])
ORDER BY AOV DESC;

/*
Câu hỏi đặt ra: 
- Tại sao doanh thu của năm 2023 cao mà AOV lại thấp ?
- Tại sao năm từ năm 2022 tới năm 2023, Khách hàng: Vip, Potential, Loyalist tăng nhưng mà AOV của năm 2022 cao hơn năm 2023 ?
Trả lời:
-Câu 1: Ta có thể thấy trong năm 2022 cho tới năm 2023 AOV của năm 2023 giảm 10,3% so với năm 2022, và dựa vào câu truy vấn 'doanh thu và số lượng đơn hàng theo từng năm'
thì ta có thể thấy rằng số lượng đơn hàng của năm 2023 lớn hơn so với đơn hàng của năm 2022 và ta có thể đoán ra được rằng cửa hàng đang đẩy mạnh các chiến dịch
lấy số lượng bù chất lượng cho nên có thể doanh thu cao nhưng AOV lại thấp

-Câu 2:  Dựa vào câu truy vấn RFM tớ có thể thấy khách hàng Potential tăng rất cao cho thấy chiến dịch lấy số lượng bù chất lượng đã đạt chất lượng cao, có thể trong năm này
cửa hàng đã chạy các chương trình như là giảm giá sâu, tung ra các combo giá rẻ,.... để thu hút khách hàng tiềm năng. Trong chiến dịch này có thể cửa hàng muốn kéo nhóm
khách hàng At risk quay lại nhưng mà đây là nhóm khách hàng thường xuyên mua những đơn hàng ít và rẻ cho nên khiến cho AOV của năm 2023 giảm so với năm 2022 mặc dù đây là một
chiến dịch thành công khi thu về doanh thu cao hơn năm 2022

- Nhưng qua đó chúng ta có một bức tranh rõ ràng hơn rằng: Những chiến dịch này đã thành công trong năm 2023 nhưng nó khiến cho năm 2024 bị sụt giảm nghiêm trọng có thể do một số
nguyên nhân sau
Thứ nhất: Các khách hàng Vip, Khách hàng trung thành bị cảm thấy không được đặc biệt coi trọng, hoặc có thể họ chỉ chờ đến các dịp khuyến mãi mới mua nên cửa hàng đã mất đi 
khách hàng cốt lõi của chính mình.

Thứ hai: Nhìn vào RFM ta có thể thấy, Sang năm 2024, hai nhóm quan trọng nhất của bạn đều suy giảm: Loyal Customers (2169 -> 1792) và Regular (3476 -> 3067) đều giảm mạnh. 
Đây là lý do chính khiến doanh thu 2024 giảm sút

Thứ ba: khách hàng ỷ lại chờ khi nào có khuyến mãi mới mua và khiến cho doanh số của năm 2024 bị giảm rất mạnh
*/


-- Phần III: Đưa ra các chiến lược, giải pháp tối ưu chi phí, tăng trưởng doanh thu cho cửa hàng trong thời gian tới

-- Phân tích giỏ hàng 
SELECT TOP 10 A.[Tên mặt hàng],B.[Tên mặt hàng],COUNT(*) AS Frequency FROM 
Sales AS A JOIN Sales AS B ON A.[Mã đơn hàng] = B.[Mã đơn hàng] AND A.[Mã mặt hàng] < B.[Mã mặt hàng]
GROUP BY A.[Tên mặt hàng],B.[Tên mặt hàng]
ORDER BY COUNT(*) DESC;

-- Phân tích thời gian trong năm (tháng)
SELECT CONCAT('Tháng ',MONTH([Thời gian tạo đơn])) AS Month, SUM([Thành tiền])/COUNT(distinct[Mã đơn hàng]) AS AOV FROM Sales
GROUP BY MONTH([Thời gian tạo đơn]) 
ORDER BY AOV DESC;

-- Phân tích thời gian trong năm (khung giờ)
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

/* Đưa ra chiến lược:
- Phân tích giỏ hàng: 
-> Đưa ra các chiến lược cross-selling, ví dụ khi khách mua trà gừng thì sẽ gợi ý các mặt hàng đi kèm như là
bột cần tây, cam lát, trà đường nhan, gợi ý cho khách hàng các combo trong giỏ hàng việc này có thể giúp tăng A0V.
-> Đưa ra các chiến lược trưng bày sản phẩm ví dụ như các món đồ thường xuyên mua cùng nhau sẽ đặt cận nhau ở trong kệ,
hay nếu bán online thì sẽ đặt gần nhau -> có thể tăng tỷ lệ mua nhiều sản phẩm trong 1 lần
-> Chúng ta có thể phân nhóm khách hàng -> nhóm thích detox, nhóm thích trà thư giản sau cho gửi voucher combo riêng cho từng nhóm khách hàng này

- Phân tích thời gian trong năm:
-> Ở đây chúng ta có thể thấy rằng AOV của cửa hàng tập trung cao nhất vào các tháng 6,7,8,10,11,12
thì đa phần sẽ tập trung vào các mùa hè, và mùa đông thì chúng ta có thể áp dụng khuyến mãi cho các tháng này
qua đó kích thích nhu cầu mua sắm của khách hàng 
Mùa hè: Khách hàng sẽ có xu hướng mua các sản phẩm detox, trà thanh nhiệt, giải độc

- Phân tích giờ làm cho nhân viên 
- Ở đây chúng ta có thể thấy rằng khung giờ ca sáng (8h-13h) là một khung giờ có chỉ số AOV cao nhất nhưng lại có doanh thu thấp
điều này chứng tỏ khách hàng tập trung vào khung giờ này sẽ có những đơn hàng có giá trị cao và thường sẽ là tệp khách hàng lớn sang trọng.

- Ca tối (18h-23h) Đây là khung giờ có doanh thu khủng bố nhất lớn nhất, ở khung giờ này chúng ta có thể nên tập trung nhiều nhân viên hơn
so với các ca khác qua đó tối ưu được chi phí của doanh nghiệp cũng như công ty.

