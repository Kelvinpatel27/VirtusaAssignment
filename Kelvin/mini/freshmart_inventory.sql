-- CLEANUP (Avoid "table exists" error)


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SalesTransactions CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Products CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Categories CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- 1. create tables

CREATE TABLE Categories (
    CategoryID NUMBER PRIMARY KEY,
    CategoryName VARCHAR2(50)
);

CREATE TABLE Products (
    ProductID NUMBER PRIMARY KEY,
    ProductName VARCHAR2(100),
    CategoryID NUMBER,
    StockCount NUMBER,
    ExpiryDate DATE,
    Price NUMBER(10,2),
    CONSTRAINT fk_category
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);

CREATE TABLE SalesTransactions (
    TransactionID NUMBER PRIMARY KEY,
    ProductID NUMBER,
    Quantity NUMBER,
    SaleDate DATE,
    CONSTRAINT fk_product
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

-- formatting stuff for output

SET LINESIZE 200
SET PAGESIZE 50
SET WRAP OFF

COLUMN ProductID FORMAT 999
COLUMN ProductName FORMAT A20
COLUMN StockCount FORMAT 999
COLUMN ExpiryDate FORMAT A15
COLUMN CategoryName FORMAT A15
COLUMN TotalRevenue FORMAT 99999.99

-- 2. sample data


-- Categories
INSERT INTO Categories VALUES (1, 'Dairy');
INSERT INTO Categories VALUES (2, 'Beverages');
INSERT INTO Categories VALUES (3, 'Snacks');

-- Products (Using SYSDATE instead of CURRENT_DATE)
INSERT INTO Products VALUES (101, 'Milk', 1, 80, SYSDATE + 5, 50);
INSERT INTO Products VALUES (102, 'Cheese', 1, 30, SYSDATE + 20, 120);
INSERT INTO Products VALUES (103, 'Yogurt', 1, 60, SYSDATE + 3, 40);
INSERT INTO Products VALUES (104, 'Cola', 2, 100, SYSDATE + 90, 35);
INSERT INTO Products VALUES (105, 'Juice', 2, 20, SYSDATE + 10, 60);
INSERT INTO Products VALUES (106, 'Chips', 3, 70, SYSDATE + 15, 20);
INSERT INTO Products VALUES (107, 'Biscuits', 3, 90, SYSDATE + 2, 25);

-- Sales Transactions
INSERT INTO SalesTransactions VALUES (1, 101, 10, SYSDATE - 10);
INSERT INTO SalesTransactions VALUES (2, 103, 15, SYSDATE - 5);
INSERT INTO SalesTransactions VALUES (3, 104, 20, SYSDATE - 15);
INSERT INTO SalesTransactions VALUES (4, 106, 25, SYSDATE - 40);

COMMIT;


-- 3. products expiring soon


PROMPT ===== Expiring Soon Products =====

SELECT ProductID, ProductName, StockCount, ExpiryDate
FROM Products
WHERE ExpiryDate BETWEEN SYSDATE AND SYSDATE + 7
AND StockCount > 50;

-- 4. dead stock check


PROMPT ===== Dead Stock (No sales in last 60 days) =====

-- products that havent sold in 60 days
select p.ProductID, p.ProductName
FROM Products p
LEFT JOIN SalesTransactions s
ON p.ProductID = s.ProductID
AND s.SaleDate >= SYSDATE - 60
WHERE s.ProductID IS NULL;

-- 5. revenue by category last month


PROMPT ===== Revenue by Category (Last Month) =====

-- tried doing this with a subquery first but joins are easier
-- SELECT c.CategoryName, SUM(s.Quantity * p.Price) FROM SalesTransactions s, Products p, Categories c WHERE s.ProductID = p.ProductID AND p.CategoryID = c.CategoryID GROUP BY c.CategoryName;
SELECT c.CategoryName,
       SUM(s.Quantity * p.Price) AS TotalRevenue
FROM SalesTransactions s
JOIN Products p ON s.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE s.SaleDate >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1)
AND s.SaleDate < TRUNC(SYSDATE, 'MM')
GROUP BY c.CategoryName
ORDER BY TotalRevenue DESC;