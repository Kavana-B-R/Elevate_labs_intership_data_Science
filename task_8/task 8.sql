CREATE DATABASE IF NOT EXISTS task8_house;
USE task8_house;

DROP TABLE IF EXISTS house_prices;

CREATE TABLE house_prices (
    Id INT,
    OverallQual INT,
    GrLivArea INT,
    SalePrice DECIMAL(12,2),
    YearBuilt INT,
    Neighborhood VARCHAR(50),
    SaleCondition VARCHAR(50)
);

INSERT INTO house_prices VALUES
(1,7,1710,208500,2003,'CollgCr','Normal'),
(2,6,1262,181500,1976,'Veenker','Normal'),
(3,7,1786,223500,2001,'CollgCr','Normal'),
(4,7,1717,140000,1915,'Crawfor','Abnorml'),
(5,8,2198,250000,2000,'NoRidge','Normal'),
(6,5,1362,143000,1993,'Mitchel','Normal'),
(7,8,1694,307000,2004,'NoRidge','Normal'),
(8,7,2090,200000,1973,'Somerst','Normal'),
(9,7,1774,129900,1931,'OldTown','Abnorml'),
(10,5,1077,118000,1939,'BrkSide','Normal'),
(11,8,2324,345000,2005,'NoRidge','Normal'),
(12,6,1456,144000,1965,'NAmes','Normal'),
(13,7,1640,185000,1962,'NAmes','Normal'),
(14,6,1494,230000,2006,'NridgHt','Normal'),
(15,9,2392,450000,2007,'NridgHt','Normal');

SELECT
    Neighborhood,
    AVG(SalePrice) AS avg_sale_price
FROM house_prices
GROUP BY Neighborhood;

SELECT
    Id,
    Neighborhood,
    SalePrice,
    ROW_NUMBER() OVER (
        ORDER BY SalePrice DESC
    ) AS row_num
FROM house_prices;

SELECT
    Id,
    Neighborhood,
    SalePrice,
    RANK() OVER (
        PARTITION BY Neighborhood
        ORDER BY SalePrice DESC
    ) AS rank_value,
    DENSE_RANK() OVER (
        PARTITION BY Neighborhood
        ORDER BY SalePrice DESC
    ) AS dense_rank_value
FROM house_prices;

SELECT
    YearBuilt,
    SalePrice,
    SUM(SalePrice) OVER (
        ORDER BY YearBuilt
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_price
FROM house_prices
ORDER BY YearBuilt;

WITH yearly_price AS (
    SELECT
        YearBuilt,
        AVG(SalePrice) AS avg_price
    FROM house_prices
    GROUP BY YearBuilt
)
SELECT
    YearBuilt,
    avg_price,
    LAG(avg_price) OVER (ORDER BY YearBuilt) AS previous_year_price,
    (avg_price - LAG(avg_price) OVER (ORDER BY YearBuilt)) AS price_change
FROM yearly_price;

WITH ranked_houses AS (
    SELECT
        Id,
        Neighborhood,
        SalePrice,
        DENSE_RANK() OVER (
            PARTITION BY Neighborhood
            ORDER BY SalePrice DESC
        ) AS house_rank
    FROM house_prices
)
SELECT *
FROM ranked_houses
WHERE house_rank <= 3;
