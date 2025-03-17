-- Добавляем столбец TotalSum для расчета общей суммы заказа
  
ALTER TABLE CleanedData ADD COLUMN "TotalSum" NUMERIC;
UPDATE CleanedData SET "TotalSum" = "Quantity" * "Price";

SELECT * FROM CleanedData;
ALTER TABLE CleanedData ADD COLUMN IF NOT EXISTS "TotalSum" NUMERIC;

UPDATE CleanedData SET "TotalSum" = "Quantity" * "Price";

SELECT COUNT(DISTINCT "Customer ID") AS UniqueCustomerCount --5878 уникальных клиентов
FROM CleanedData;


--RFM СЕГМЕНТАЦИЯ 

WITH RFM AS (
    SELECT "Customer ID",
           MAX("InvoiceDate") AS LastPurchaseDate,
           COUNT(DISTINCT "Invoice") AS Frequency,
           SUM("TotalSum") AS MonetaryValue
    FROM CleanedData
    GROUP BY "Customer ID"
),
RFM_Calc AS (
  SELECT r.*,
         NTILE(4) OVER (ORDER BY LastPurchaseDate DESC) AS R_Score,
         NTILE(4) OVER (ORDER BY Frequency) AS F_Score,
         NTILE(4) OVER (ORDER BY MonetaryValue) AS M_Score
  FROM RFM r
)
SELECT 
    CustomerSegment,
    COUNT(*) AS TotalCustomers
FROM (
    SELECT 
        "Customer ID",
        CASE
            WHEN R_Score = 4 THEN 'Новые клиенты'
            WHEN R_Score = 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'Золотые клиенты'
            WHEN R_Score = 3 AND (F_Score < 3 OR M_Score < 3) THEN 'Регулярные клиенты'
            WHEN R_Score = 2 AND F_Score >= 2 AND M_Score >= 2 THEN 'Регулярные клиенты'
            WHEN R_Score = 2 AND (F_Score < 2 OR M_Score < 2) THEN 'Риск'
            WHEN R_Score = 1 THEN 'Потерянные (Churn)' 
        END AS CustomerSegment
    FROM RFM_Calc
) AS CustomerSegments
GROUP BY CustomerSegment;

--квантование на 4 группы выглядит более однородным, поэтому оставим его.

SELECT * FROM CleanedData;

ALTER TABLE CleanedData ADD COLUMN CustomerSegment TEXT; --добавила стобец с сегментами

UPDATE CleanedData
SET CustomerSegment = sub.CustomerSegment
FROM (SELECT "Customer ID",
             CASE
                 WHEN R_Score = 4 THEN 'Новые клиенты'
                 WHEN R_Score = 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'Золотые клиенты'
                 WHEN R_Score = 3 AND (F_Score < 3 OR M_Score < 3) THEN 'Регулярные клиенты'
                 WHEN R_Score = 2 AND F_Score >= 2 AND M_Score >= 2 THEN 'Регулярные клиенты'
                 WHEN R_Score = 2 AND (F_Score < 2 OR M_Score < 2) THEN 'Риск'
                 WHEN R_Score = 1 THEN 'Потерянные (Churn)'
             END AS CustomerSegment
      FROM (SELECT "Customer ID",
                   NTILE(4) OVER (ORDER BY LastPurchaseDate DESC) AS R_Score,
                   NTILE(4) OVER (ORDER BY Frequency) AS F_Score,
                   NTILE(4) OVER (ORDER BY MonetaryValue) AS M_Score
            FROM (SELECT "Customer ID",
                         MAX("InvoiceDate") AS LastPurchaseDate,
                         COUNT(DISTINCT "Invoice") AS Frequency,
                         SUM("TotalSum") AS MonetaryValue
                  FROM CleanedData
                  GROUP BY "Customer ID") as rfm) as rfm_calc) AS sub
WHERE CleanedData."Customer ID" = sub."Customer ID";

SELECT * FROM CleanedData;