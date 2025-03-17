--поиск и удаление дубликатов

CREATE TEMP TABLE UniqueRows AS
WITH RankedRows AS (
    SELECT "Invoice", "StockCode", "Description", "Quantity", "InvoiceDate", "Price", "Customer ID", "Country",
           ROW_NUMBER() OVER (PARTITION BY "Invoice", "StockCode", "Description", "Quantity", "InvoiceDate", "Price", "Customer ID", "Country" ORDER BY "InvoiceDate") as rn
    FROM pet_projects.public."online_retail_II"
)
SELECT "Invoice", "StockCode", "Description", "Quantity", "InvoiceDate", "Price", "Customer ID", "Country"
FROM RankedRows
WHERE rn = 1;

SELECT * FROM UniqueRows; -- Просмотр содержимого временной таблицы

SELECT COUNT(*) FROM pet_projects.public."online_retail_II"; -- Количество строк в исходной таблице 1 067 371
SELECT COUNT(*) FROM UniqueRows; -- Количество строк во временной таблице 1 033 036, то есть в итоге получилось 34 335 дубликатов

CREATE TABLE CleanedData AS
SELECT *
FROM UniqueRows
WHERE "Quantity" > 0 -- Удаляем строки с минусовым количеством
  AND "Price" > 0   -- Удаляем строки с минусовой или нулевой ценой
  AND "Customer ID" IS NOT NULL -- Удаляем строки с пропущенными Customer ID
  AND "Invoice" NOT LIKE 'C%'; -- Удаляем строки, начинающиеся с 'C' (обычно это возвраты)


