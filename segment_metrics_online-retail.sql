--дополнительные метрики

--средний чек для каждого клиента

ALTER TABLE CleanedData ADD COLUMN AverageOrderValue REAL;

UPDATE CleanedData --округлили до 2 знаков после запятой
SET AverageOrderValue = sub.AvgOrderValue
FROM (SELECT "Customer ID",
      ROUND(CAST(SUM("TotalSum") AS NUMERIC) / COUNT(DISTINCT "Invoice"), 2) AS AvgOrderValue
      FROM CleanedData
      GROUP BY "Customer ID") AS sub
WHERE CleanedData."Customer ID" = sub."Customer ID";


CREATE TABLE IF NOT EXISTS CustomerSegmentMetrics AS 
WITH CustomerMonetaryValue AS (
    SELECT
        "Customer ID",
        SUM("TotalSum") as MonetaryValue
    FROM CleanedData
    GROUP BY "Customer ID"
), CountrySegmentMetrics AS (
    SELECT
        cd."customersegment", 
        cd."Country",
        COUNT(DISTINCT cd."Customer ID") AS CustomerCount,
        ROUND(SUM(cmv.MonetaryValue), 2) AS TotalMonetaryValue,
        ROUND(AVG(cmv.MonetaryValue), 2) AS AvgMonetaryValuePerCustomer,
        COUNT(DISTINCT cd."Invoice") AS TotalOrders
    FROM CleanedData cd
    JOIN CustomerMonetaryValue cmv ON cd."Customer ID" = cmv."Customer ID"
    GROUP BY cd."customersegment", cd."Country" 
), SegmentTotals AS (
    SELECT
        "customersegment", 
        SUM(CustomerCount) AS TotalCustomersPerSegment
    FROM CountrySegmentMetrics
    GROUP BY "customersegment" 
)
SELECT
    csm."customersegment",
    csm."Country",
    csm.CustomerCount,
    csm.TotalMonetaryValue,
    csm.AvgMonetaryValuePerCustomer,
    csm.TotalOrders,
    ROUND((csm.CustomerCount::NUMERIC / st.TotalCustomersPerSegment) * 100, 2) AS CustomerSharePercentage
FROM CountrySegmentMetrics csm
JOIN SegmentTotals st ON csm."customersegment" = st."customersegment" 
ORDER BY csm."customersegment", csm."Country";


SELECT * FROM CustomerSegmentMetrics;