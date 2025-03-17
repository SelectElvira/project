SELECT 
    AVG("Quantity") AS AvgQuantity,--исследование сегмента, где Customer ID пустой
    MIN("Quantity") AS MinQuantity,
    MAX("Quantity") AS MaxQuantity,
    STDDEV("Quantity") AS StdDevQuantity,
    AVG("Price") AS AvgPrice,
    MIN("Price") AS MinPrice,
    MAX("Price") AS MaxPrice,
    STDDEV("Price") AS StdDevPrice
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL; 

SELECT SUM("Price" * "Quantity") AS TotalRevenueFromMissingIDs --2638958.18
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL; 

--общая статистика
SELECT *
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL;

SELECT COUNT(*) AS total_nullprice, -- нулевые значения цены - 6202 строк
SUM(CASE WHEN "Price" = 0 THEN 1 ELSE 0 END) AS null_pricecount
FROM pet_projects.public."online_retail_II";

SELECT DATE("InvoiceDate") AS InvoiceDateOnly, COUNT(*) AS TransactionCount -- исследование сегмента потерянных CustomerID 
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL
  AND "Price" != 0 -- Цена не равна 0
  AND "Quantity" > 0 -- Количество больше 0
  AND "Invoice" NOT LIKE 'C%' -- Инвойс не начинается с 'C'
GROUP BY DATE("InvoiceDate")
ORDER BY DATE("InvoiceDate");

SELECT DATE("InvoiceDate") AS InvoiceDate, --выручка по дням
       SUM("Price" * "Quantity") AS RevenueFromNullCustomers
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL
  AND "Price" > 0
  AND "Quantity" > 0
GROUP BY DATE("InvoiceDate");

SELECT SUM(CASE WHEN "Invoice" NOT LIKE 'C%' THEN "Price" * "Quantity" ELSE 0 END) AS TotalRevenue, --3 229 165.39
       COUNT(DISTINCT CASE WHEN "Invoice" NOT LIKE 'C%' THEN "Invoice" ELSE NULL END) AS TotalTransactions, --3108
       COUNT(DISTINCT CASE WHEN "Invoice" LIKE 'C%' THEN "Invoice" ELSE NULL END) AS CancelledTransactions --1
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL
  AND "Price" > 0
  AND "Quantity" > 0;

--СРЕДНИЙ ЧЕК
SELECT AVG("Price" * "Quantity") AS AverageTransactionValue --13.675
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL
  AND "Price" > 0
  AND "Quantity" > 0
  AND "Invoice" NOT LIKE 'C%';

SELECT DATE_TRUNC('month', "InvoiceDate") AS Month,--продажи по месяцам
       SUM("Price" * "Quantity") AS MonthlyRevenue
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL
  AND "Price" > 0
  AND "Quantity" > 0
  AND "Invoice" NOT LIKE 'C%'
GROUP BY Month
ORDER BY Month;

SELECT EXTRACT(DOW FROM "InvoiceDate") AS DayOfWeek, --продажи по дням недели, где 0 - воскресенье, 6 - суббота
       SUM("Price" * "Quantity") AS RevenueByDayOfWeek
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL
  AND "Price" > 0
  AND "Quantity" > 0
  AND "Invoice" NOT LIKE 'C%'
GROUP BY DayOfWeek
ORDER BY DayOfWeek;

SELECT EXTRACT(HOUR FROM "InvoiceDate") AS HourOfDay, --продажи по часам в сутки
       SUM("Price" * "Quantity") AS RevenueByHourOfDay
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL
  AND "Price" > 0
  AND "Quantity" > 0
  AND "Invoice" NOT LIKE 'C%'
GROUP BY HourOfDay
ORDER BY HourOfDay;

SELECT AVG("Price") AS AveragePrice --средняя цена 7.045
FROM pet_projects.public."online_retail_II"
WHERE "Customer ID" IS NULL
  AND "Price" > 0
  AND "Quantity" > 0
  AND "Invoice" NOT LIKE 'C%';


