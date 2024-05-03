/*III. Tạo metric trước khi dựng dashboard
1) Giả sử team của bạn đang cần dựng dashboard và có yêu cầu xử lý dữ liệu trước khi kết nối với BI tool. Sau khi bàn bạc, team của bạn quyết định các metric cần thiết cho dashboard và cần phải trích xuất dữ liệu từ database để ra được 1 dataset như mô tả Yêu cầu dataset

Hãy sử dụng câu lệnh SQL để tạo ra 1 dataset như mong muốn và lưu dataset đó vào VIEW đặt tên là vw_ecommerce_analyst */
-- https://docs.google.com/document/d/1atYrP3m_AVK2jv0cDMpQlmWLsRRkuI5gpcTgzB5GnBU/edit


WITH CTE AS (
    SELECT 
        b.order_id,
        b.id,
        b.user_id,
        FORMAT_TIMESTAMP('%Y-%m', a.created_at) AS Month,
        EXTRACT(YEAR FROM a.created_at) AS Year,
        c.category AS Product_category,
        CAST(b.sale_price AS NUMERIC) AS sale_price,
        a.num_of_item,
        CAST(c.cost AS NUMERIC) AS cost
    FROM 
        bigquery-public-data.thelook_ecommerce.orders AS a 
        INNER JOIN bigquery-public-data.thelook_ecommerce.order_items AS b ON a.order_id = b.order_id
        INNER JOIN bigquery-public-data.thelook_ecommerce.products AS c ON c.id = b.id
    
    ORDER BY 
        c.category, FORMAT_TIMESTAMP('%Y-%m', a.created_at)
),
CTE_2 AS (
    SELECT 
        * 
    FROM (
        SELECT 
            t.*,
            ROW_NUMBER() OVER (PARTITION BY order_id, id, user_id, num_of_item, Product_category ORDER BY Month) AS dup_flag
        FROM 
            CTE t
    )
    WHERE 
        dup_flag = 1
),
CTE_3 AS (
    SELECT 
        Month, 
        Year, 
        Product_category, 
        ROUND(SUM(sale_price * num_of_item), 2) AS TPV, 
        SUM(num_of_item) AS TPO, 
        ROUND(SUM(cost * num_of_item), 2) AS Total_Cost
    FROM 
        CTE_2
    GROUP BY 
        Product_category, Month, Year
    ORDER BY 
        Product_category, Month
)
SELECT 
    *, 
    CONCAT(ROUND(100 * (TPV - LAG(TPV) OVER (PARTITION BY Product_category ORDER BY Month)) / LAG(TPV) OVER (PARTITION BY Product_category ORDER BY Month), 2), '%') AS Revenue_growth,
    CONCAT(ROUND(100 * (TPO - LAG(TPO) OVER (PARTITION BY Product_category ORDER BY Month)) / LAG(TPO) OVER (PARTITION BY Product_category ORDER BY Month), 2), '%') AS Order_growth,
    TPV - Total_Cost AS Total_profit,
    CONCAT(ROUND(100 * ((TPV - Total_Cost) / Total_Cost), 2), '%') AS Profit_to_cost_ratio
FROM 
    CTE_3;


/* 2) Tạo retention cohort analysis.
Lưu ý: Ở mỗi cohort chỉ theo dõi 3 tháng (indext từ 1 đến 4)
Ví dụ:

Ở phạm vi chương trình này, bạn hãy visualize thêm 1 cohort analysis trên excel nha.
Sau đó hãy tìm insight từ cohort analysis đó rồi đưa ra vài đề xuất giúp cải thiện tình hình kinh doanh của công ty */




