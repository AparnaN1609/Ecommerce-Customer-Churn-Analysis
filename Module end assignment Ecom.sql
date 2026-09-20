SHOW DATABASES;
USE ecomm;
SHOW TABLES;
DESCRIBE customer_churn;
SELECT *
FROM customer_churn
LIMIT 10;
CREATE TABLE customer_churn_backup AS
SELECT *
FROM customer_churn;
SELECT COUNT(*) AS BackupRecordCount
FROM customer_churn_backup;

UPDATE customer_churn
SET WarehouseToHome = (
    SELECT mean_value
    FROM (
        SELECT ROUND(AVG(WarehouseToHome)) AS mean_value
        FROM customer_churn
        WHERE WarehouseToHome IS NOT NULL
    ) AS temp
)
WHERE WarehouseToHome IS NULL;

SET SQL_SAFE_UPDATES = 0;
UPDATE customer_churn
SET WarehouseToHome = (
    SELECT mean_value
    FROM (
        SELECT ROUND(AVG(WarehouseToHome)) AS mean_value
        FROM customer_churn
        WHERE WarehouseToHome IS NOT NULL
    ) AS temp
)
WHERE WarehouseToHome IS NULL;
SET SQL_SAFE_UPDATES = 1;
SELECT COUNT(*) AS Remaining_NULLs
FROM customer_churn
WHERE WarehouseToHome IS NULL;
UPDATE customer_churn
SET HourSpendOnApp = (
    SELECT mean_value
    FROM (
        SELECT ROUND(AVG(HourSpendOnApp)) AS mean_value
        FROM customer_churn
        WHERE HourSpendOnApp IS NOT NULL
    ) AS temp
)
WHERE HourSpendOnApp IS NULL;

SET SQL_SAFE_UPDATES = 0;
UPDATE customer_churn
SET HourSpendOnApp = (
    SELECT mean_value
    FROM (
        SELECT ROUND(AVG(HourSpendOnApp)) AS mean_value
        FROM customer_churn
        WHERE HourSpendOnApp IS NOT NULL
    ) AS temp
)
WHERE HourSpendOnApp IS NULL;
SELECT COUNT(*) AS Remaining_NULLs
FROM customer_churn
WHERE HourSpendOnApp IS NULL;
UPDATE customer_churn
SET OrderAmountHikeFromlastYear = (
    SELECT mean_value
    FROM (
        SELECT ROUND(AVG(OrderAmountHikeFromlastYear)) AS mean_value
        FROM customer_churn
        WHERE OrderAmountHikeFromlastYear IS NOT NULL
    ) AS temp
)
WHERE OrderAmountHikeFromlastYear IS NULL;
SELECT COUNT(*) AS Remaining_NULLs
FROM customer_churn
WHERE OrderAmountHikeFromlastYear IS NULL;
UPDATE customer_churn
SET DaySinceLastOrder = (
    SELECT mean_value
    FROM (
        SELECT ROUND(AVG(DaySinceLastOrder)) AS mean_value
        FROM customer_churn
        WHERE DaySinceLastOrder IS NOT NULL
    ) AS temp
)
WHERE DaySinceLastOrder IS NULL;
SELECT COUNT(*) AS Remaining_NULLs
FROM customer_churn
WHERE DaySinceLastOrder IS NULL;
UPDATE customer_churn
SET Tenure = (
    SELECT mode_value
    FROM (
        SELECT Tenure AS mode_value
        FROM customer_churn
        WHERE Tenure IS NOT NULL
        GROUP BY Tenure
        ORDER BY COUNT(*) DESC, Tenure ASC
        LIMIT 1
    ) AS temp
)
WHERE Tenure IS NULL;
SELECT COUNT(*) AS Remaining_NULLs
FROM customer_churn
WHERE Tenure IS NULL;
UPDATE customer_churn
SET CouponUsed = (
    SELECT mode_value
    FROM (
        SELECT CouponUsed AS mode_value
        FROM customer_churn
        WHERE CouponUsed IS NOT NULL
        GROUP BY CouponUsed
        ORDER BY COUNT(*) DESC, CouponUsed ASC
        LIMIT 1
    ) AS temp
)
WHERE CouponUsed IS NULL;
SELECT COUNT(*) AS Remaining_NULLs
FROM customer_churn
WHERE CouponUsed IS NULL;
UPDATE customer_churn
SET OrderCount = (
    SELECT mode_value
    FROM (
        SELECT OrderCount AS mode_value
        FROM customer_churn
        WHERE OrderCount IS NOT NULL
        GROUP BY OrderCount
        ORDER BY COUNT(*) DESC, OrderCount ASC
        LIMIT 1
    ) AS temp
)
WHERE OrderCount IS NULL;

SELECT COUNT(*) AS Remaining_NULLs
FROM customer_churn
WHERE OrderCount IS NULL;

DELETE FROM customer_churn
WHERE WarehouseToHome > 100;
SELECT COUNT(*) AS Invalid_Records
FROM customer_churn
WHERE WarehouseToHome > 100;
UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';
SELECT PreferredLoginDevice, COUNT(*) AS Total
FROM customer_churn
GROUP BY PreferredLoginDevice;
UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';
SELECT PreferedOrderCat, COUNT(*) AS Total
FROM customer_churn
GROUP BY PreferedOrderCat;
UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';
SELECT PreferredPaymentMode, COUNT(*) AS Total
FROM customer_churn
GROUP BY PreferredPaymentMode;

ALTER TABLE customer_churn
CHANGE COLUMN PreferedOrderCat PreferredOrderCat VARCHAR(20);
ALTER TABLE customer_churn
CHANGE COLUMN HourSpendOnApp HoursSpentOnApp INT;
ALTER TABLE customer_churn
ADD COLUMN ComplaintReceived VARCHAR(3);
UPDATE customer_churn
SET ComplaintReceived =
    CASE
        WHEN Complain = 1 THEN 'Yes'
        ELSE 'No'
    END;
SELECT ComplaintReceived, COUNT(*) AS Total
FROM customer_churn
GROUP BY ComplaintReceived;
ALTER TABLE customer_churn
ADD COLUMN ChurnStatus VARCHAR(7);
UPDATE customer_churn
SET ChurnStatus =
    CASE
        WHEN Churn = 1 THEN 'Churned'
        ELSE 'Active'
    END;
SELECT ChurnStatus, COUNT(*) AS Total
FROM customer_churn
GROUP BY ChurnStatus;

ALTER TABLE customer_churn
DROP COLUMN Churn,
DROP COLUMN Complain;
DESCRIBE customer_churn;
SELECT ChurnStatus, COUNT(*) AS TotalCustomers
FROM customer_churn
GROUP BY ChurnStatus;
SELECT
    ROUND(AVG(Tenure), 2) AS AverageTenure,
    SUM(CashbackAmount) AS TotalCashback
FROM customer_churn
WHERE ChurnStatus = 'Churned';
SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN ComplaintReceived = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS ComplaintPercentage
FROM customer_churn
WHERE ChurnStatus = 'Churned';
SELECT
    CityTier,
    COUNT(*) AS TotalCustomers
FROM customer_churn
WHERE ChurnStatus = 'Churned'
  AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY TotalCustomers DESC
LIMIT 1;

SELECT
    PreferredPaymentMode,
    COUNT(*) AS TotalCustomers
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY TotalCustomers DESC
LIMIT 1;
SELECT
    SUM(OrderAmountHikeFromlastYear) AS TotalOrderAmountIncrease
FROM customer_churn
WHERE MaritalStatus = 'Single'
  AND PreferredOrderCat = 'Mobile Phone';
  
SELECT
    ROUND(AVG(NumberOfDeviceRegistered), 2) AS AverageDevices
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';
SELECT
    CityTier,
    COUNT(*) AS TotalCustomers
FROM customer_churn
GROUP BY CityTier
ORDER BY TotalCustomers DESC
LIMIT 1;

SELECT
    Gender,
    SUM(CouponUsed) AS TotalCouponsUsed
FROM customer_churn
GROUP BY Gender
ORDER BY TotalCouponsUsed DESC
LIMIT 1;
SELECT
    PreferredOrderCat,
    COUNT(*) AS TotalCustomers,
    MAX(HoursSpentOnApp) AS MaximumHoursSpent
FROM customer_churn
GROUP BY PreferredOrderCat;
SELECT
    SUM(OrderCount) AS TotalOrders
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
  AND SatisfactionScore = (
      SELECT MAX(SatisfactionScore)
      FROM customer_churn
  );

SELECT
    ROUND(AVG(SatisfactionScore), 2) AS AverageSatisfactionScore
FROM customer_churn
WHERE ComplaintReceived = 'Yes';

SELECT DISTINCT PreferredOrderCat
FROM customer_churn
WHERE CouponUsed > 5;

SELECT
    PreferredOrderCat,
    ROUND(AVG(CashbackAmount), 2) AS AverageCashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY AverageCashback DESC
LIMIT 3;

SELECT
    PreferredPaymentMode,
    ROUND(AVG(Tenure), 2) AS AverageTenure,
    SUM(OrderCount) AS TotalOrders
FROM customer_churn
GROUP BY PreferredPaymentMode
HAVING AVG(Tenure) = 10
   AND SUM(OrderCount) > 500;
   
  SELECT
    ChurnStatus,
    CASE
        WHEN WarehouseToHome <= 5 THEN 'Very Close'
        WHEN WarehouseToHome <= 10 THEN 'Close'
        WHEN WarehouseToHome <= 15 THEN 'Moderate'
        ELSE 'Far'
    END AS DistanceCategory,
    COUNT(*) AS TotalCustomers
FROM customer_churn
GROUP BY
    ChurnStatus,
    DistanceCategory
ORDER BY ChurnStatus, DistanceCategory; 
   
SELECT
    CustomerID,
    MaritalStatus,
    CityTier,
    OrderCount
FROM customer_churn
WHERE MaritalStatus = 'Married'
  AND CityTier = 1
  AND OrderCount > (
      SELECT AVG(OrderCount)
      FROM customer_churn
  );

CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount INT
);

INSERT INTO customer_returns
    (ReturnID, CustomerID, ReturnDate, RefundAmount)
VALUES
    (1001, 50022, '2023-01-01', 2130),
    (1002, 50316, '2023-01-23', 2000),
    (1003, 51099, '2023-02-14', 2290),
    (1004, 52321, '2023-03-08', 2510),
    (1005, 52928, '2023-03-20', 3000),
    (1006, 53749, '2023-04-17', 1740),
    (1007, 54206, '2023-04-21', 3250),
    (1008, 54838, '2023-04-30', 1990);

SELECT *
FROM customer_returns;

SELECT
    r.ReturnID,
    r.CustomerID,
    r.ReturnDate,
    r.RefundAmount,
    c.ChurnStatus,
    c.ComplaintReceived
FROM customer_returns AS r
INNER JOIN customer_churn AS c
    ON r.CustomerID = c.CustomerID
WHERE c.ChurnStatus = 'Churned'
  AND c.ComplaintReceived = 'Yes';
  
  SELECT COUNT(*) AS TotalCustomers
FROM customer_churn;

SELECT *
FROM customer_churn
LIMIT 10;

DESCRIBE customer_churn;
SHOW TABLES;
SET SQL_SAFE_UPDATES = 1;
