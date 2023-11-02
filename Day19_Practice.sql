--bài tập 1 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE numeric USING (TRIM(ordernumber):: numeric)
  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE numeric USING (TRIM(quantityordered):: numeric)
  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (TRIM(priceeach):: numeric)
  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE numeric USING (TRIM(orderlinenumber):: numeric)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE float USING (TRIM(sales):: float)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE numeric USING (TRIM(msrp):: numeric)

-- bài tập 2 
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
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(20),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(20);


