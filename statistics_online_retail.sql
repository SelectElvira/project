SELECT * 
from pet_projects.public."online_retail_II";

SELECT * 
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'online_retail_II'; --проверила структуру таблицы и тип данных

ALTER TABLE pet_projects.public."online_retail_II" 
ALTER COLUMN "Quantity" TYPE numeric USING "Quantity"::numeric; --поменяла тип данных

ALTER TABLE pet_projects.public."online_retail_II" 
ALTER COLUMN "Price" TYPE numeric USING "Price"::numeric;

ALTER TABLE pet_projects.public."online_retail_II" 
ALTER COLUMN "InvoiceDate" TYPE timestamp USING "InvoiceDate"::timestamp;

SELECT COUNT(*) AS total_rows, --посчитала пропущенные значения
SUM(CASE WHEN "Invoice" IS NULL THEN 1 ELSE 0 END) AS null_count, -- нет
SUM(CASE WHEN "StockCode" IS NULL THEN 1 ELSE 0 END) AS null_count, -- нет
SUM(CASE WHEN "Description" IS NULL THEN 1 ELSE 0 END) AS null_count, -- 4382 (0.41%)
SUM(CASE WHEN "Quantity" IS NULL THEN 1 ELSE 0 END) AS null_count,-- нет
SUM(CASE WHEN "InvoiceDate" IS NULL THEN 1 ELSE 0 END) AS null_count,-- нет
SUM(CASE WHEN "Price" IS NULL THEN 1 ELSE 0 END) AS null_count,-- нет
SUM(CASE WHEN "Customer ID" IS NULL THEN 1 ELSE 0 END) AS null_count, --243007(22,76%) довольно большой % от общего числа
SUM(CASE WHEN "Country" IS NULL THEN 1 ELSE 0 END) AS null_count --
FROM pet_projects.public."online_retail_II";
    
