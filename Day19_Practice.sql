--bài tập 1 
---Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
SET datestyle = 'iso,mdy';  

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE numeric USING (TRIM(ordernumber)::numeric),
ALTER COLUMN quantityordered TYPE numeric USING (TRIM(quantityordered)::numeric),
ALTER COLUMN priceeach TYPE numeric USING (TRIM(priceeach)::numeric),
ALTER COLUMN orderlinenumber TYPE numeric USING (TRIM(orderlinenumber)::numeric),
ALTER COLUMN sales TYPE float USING (TRIM(sales)::float),
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate)::date),
ALTER COLUMN msrp TYPE numeric USING (TRIM(msrp)::numeric);

-- bài tập 2 
-- Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.

SELECT *
FROM sales_dataset_rfm_prj
WHERE 
    ORDERNUMBER IS NULL OR
    QUANTITYORDERED IS NULL OR
    PRICEEACH IS NULL OR
    ORDERLINENUMBER IS NULL OR
    SALES IS NULL OR
    ORDERDATE IS NULL;
-- bài tập 3 
/*Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
Gợi ý: ( ADD column sau đó UPDATE)*/
  
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(255),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(255);

UPDATE sales_dataset_rfm_prj
SET CONTACTLASTNAME = INITCAP(SUBSTRING(CONTACTFULLNAME FROM POSITION('-' IN CONTACTFULLNAME) + 1)),
    CONTACTFIRSTNAME = INITCAP(SUBSTRING(CONTACTFULLNAME FROM 1 FOR POSITION('-' IN CONTACTFULLNAME) - 1))
WHERE CONTACTFULLNAME IS NOT NULL AND POSITION('-' IN CONTACTFULLNAME) > 0;
-- bài tập 4 
/* Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE*/

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID INT,
ADD COLUMN MONTH_ID INT,
ADD COLUMN YEAR_ID INT;

UPDATE sales_dataset_rfm_prj
SET QTR_ID = EXTRACT(QUARTER FROM ORDERDATE),
    MONTH_ID = EXTRACT(MONTH FROM ORDERDATE),
    YEAR_ID = EXTRACT(YEAR FROM ORDERDATE);
-- bài tập 5 
/* Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) */
--- Phân phối chuẩn/BOXPLOT
WITH CTE AS(SELECT Q1-1.5*IQR AS min_values,
        Q3+ 1.5*IQR AS max_values 
 FROM(
	 SELECT percentile_cont (0.25) WITHIN GROUP (ORDER BY quantityordered) AS Q1,
            percentile_cont (0.75) WITHIN GROUP (ORDER BY quantityordered) AS Q3,
            percentile_cont (0.75) WITHIN GROUP (ORDER BY quantityordered)-
	        percentile_cont (0.25) WITHIN GROUP (ORDER BY quantityordered) AS IQR
     FROM sales_dataset_rfm_prj) 
AS SUB_QUERY)
-- xác định outliner
SELECT * FROM sales_dataset_rfm_prj
WHERE quantityordered < (SELECT min_values FROM CTE ) OR
      quantityordered > (SELECT max_values FROM CTE )

  
  --- sử dụng Z-score 
SELECT avg(QUANTITYORDERED),
stddev(QUANTITYORDERED)
FROM sales_dataset_rfm_prj

with cte as
(SELECT orderdate,QUANTITYORDERED,(avg(QUANTITYORDERED) FROM sales_dataset_rfm_prj) AS avg,
(stddev(QUANTITYORDERED) FROM sales_dataset_rfm_prj) AS stddev
FROM sales_dataset_rfm_prj)
,twt_outliner AS(
SELECT orderdate,QUANTITYORDERED,(QUANTITYORDERED-avg)/stddev AS z_score
from cte 
where ABS ((QUANTITYORDERED-avg)/stddev)>2)

UPDATE sales_dataset_rfm_prj
SET QUANTITYORDERED=(SELECT avg(QUANTITYORDERED) FROM sales_dataset_rfm_prj)
WHERE QUANTITYORDERED IN(SELECT QUANTITYORDERED FROM twt_outliner);

DELETE FROM sales_dataset_rfm_prj
WHERE QUANTITYORDERED IN(SELECT QUANTITYORDERED FROM twt_outliner);

-- bài tập 6 
--- lưu bảng với tên mới 
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
SELECT *
FROM sales_dataset_rfm_prj.






