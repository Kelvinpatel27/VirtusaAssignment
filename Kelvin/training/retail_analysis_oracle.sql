-- drop if exists
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Order_Items'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Orders'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Products'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Customers'; EXCEPTION WHEN OTHERS THEN NULL; END;
/


CREATE TABLE Customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    city VARCHAR2(50)
);

CREATE TABLE Products (
    product_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    category VARCHAR2(50),
    price NUMBER(10,2)
);

CREATE TABLE Orders (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    order_date DATE,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_id NUMBER,
    product_id NUMBER,
    quantity NUMBER,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id)
    REFERENCES Products(product_id)
);

-- sample data

INSERT INTO Customers VALUES (1, 'Ravi Kumar', 'Hyderabad');
INSERT INTO Customers VALUES (2, 'Anita Sharma', 'Delhi');
INSERT INTO Customers VALUES (3, 'Rahul Verma', 'Mumbai');
INSERT INTO Customers VALUES (4, 'Sneha Reddy', 'Bangalore');
INSERT INTO Customers VALUES (5, 'Amit Patel', 'Ahmedabad');

INSERT INTO Products VALUES (101, 'Laptop', 'Electronics', 50000);
INSERT INTO Products VALUES (102, 'Smartphone', 'Electronics', 20000);
INSERT INTO Products VALUES (103, 'Headphones', 'Accessories', 2000);
INSERT INTO Products VALUES (104, 'Office Chair', 'Furniture', 7000);
INSERT INTO Products VALUES (105, 'Desk Lamp', 'Furniture', 1500);

INSERT INTO Orders VALUES (1001, 1, TO_DATE('2026-04-01','YYYY-MM-DD'));
INSERT INTO Orders VALUES (1002, 2, TO_DATE('2026-04-03','YYYY-MM-DD'));
INSERT INTO Orders VALUES (1003, 1, TO_DATE('2026-05-10','YYYY-MM-DD'));
INSERT INTO Orders VALUES (1004, 3, TO_DATE('2026-05-15','YYYY-MM-DD'));
INSERT INTO Orders VALUES (1005, 4, TO_DATE('2026-06-01','YYYY-MM-DD'));

INSERT INTO Order_Items VALUES (1001, 101, 1);
INSERT INTO Order_Items VALUES (1001, 103, 2);
INSERT INTO Order_Items VALUES (1002, 102, 1);
INSERT INTO Order_Items VALUES (1002, 105, 3);
INSERT INTO Order_Items VALUES (1003, 104, 1);
INSERT INTO Order_Items VALUES (1003, 103, 1);
INSERT INTO Order_Items VALUES (1004, 101, 1);
INSERT INTO Order_Items VALUES (1005, 105, 2);

COMMIT;


--- queries ---

-- what sells the most
select p.product_id, p.name AS prod_name, SUM(oi.quantity) AS total_sold
from Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC;


-- who spent the most money
SELECT c.customer_id, c.name,
       SUM(oi.quantity * p.price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- revenue per month
-- first try was wrong format, this one works
-- select TO_CHAR(o.order_date, 'Month') AS mon, SUM(oi.quantity * p.price) from Orders o, Order_Items oi, Products p where o.order_id = oi.order_id and oi.product_id = p.product_id group by TO_CHAR(o.order_date, 'Month');
SELECT TO_CHAR(o.order_date, 'YYYY-MM') AS mon,
       SUM(oi.quantity * p.price) AS rev
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY mon;

-- sales grouped by category
SELECT p.category,
       SUM(oi.quantity * p.price) AS total_sales
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- ppl who never bought anything
SELECT c.customer_id, c.name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE 1=1 AND o.order_id IS NULL;


-- repeat buyers (more then 1 order)
SELECT customer_id, COUNT(order_id) AS cnt
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;
-- Drop tables if already exist (ignore errors)
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Order_Items'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Orders'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Products'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Customers'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- TABLE CREATION

CREATE TABLE Customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    city VARCHAR2(50)
);

CREATE TABLE Products (
    product_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    category VARCHAR2(50),
    price NUMBER(10,2)
);

CREATE TABLE Orders (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    order_date DATE,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_id NUMBER,
    product_id NUMBER,
    quantity NUMBER,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id)
    REFERENCES Products(product_id)
);

-- INSERT DATA

INSERT INTO Customers VALUES (1, 'Ravi Kumar', 'Hyderabad');
INSERT INTO Customers VALUES (2, 'Anita Sharma', 'Delhi');
INSERT INTO Customers VALUES (3, 'Rahul Verma', 'Mumbai');
INSERT INTO Customers VALUES (4, 'Sneha Reddy', 'Bangalore');
INSERT INTO Customers VALUES (5, 'Amit Patel', 'Ahmedabad');

INSERT INTO Products VALUES (101, 'Laptop', 'Electronics', 50000);
INSERT INTO Products VALUES (102, 'Smartphone', 'Electronics', 20000);
INSERT INTO Products VALUES (103, 'Headphones', 'Accessories', 2000);
INSERT INTO Products VALUES (104, 'Office Chair', 'Furniture', 7000);
INSERT INTO Products VALUES (105, 'Desk Lamp', 'Furniture', 1500);

INSERT INTO Orders VALUES (1001, 1, TO_DATE('2026-04-01','YYYY-MM-DD'));
INSERT INTO Orders VALUES (1002, 2, TO_DATE('2026-04-03','YYYY-MM-DD'));
INSERT INTO Orders VALUES (1003, 1, TO_DATE('2026-05-10','YYYY-MM-DD'));
INSERT INTO Orders VALUES (1004, 3, TO_DATE('2026-05-15','YYYY-MM-DD'));
INSERT INTO Orders VALUES (1005, 4, TO_DATE('2026-06-01','YYYY-MM-DD'));

INSERT INTO Order_Items VALUES (1001, 101, 1);
INSERT INTO Order_Items VALUES (1001, 103, 2);
INSERT INTO Order_Items VALUES (1002, 102, 1);
INSERT INTO Order_Items VALUES (1002, 105, 3);
INSERT INTO Order_Items VALUES (1003, 104, 1);
INSERT INTO Order_Items VALUES (1003, 103, 1);
INSERT INTO Order_Items VALUES (1004, 101, 1);
INSERT INTO Order_Items VALUES (1005, 105, 2);

COMMIT;

-- ANALYTICAL QUERIES

-- top selling products
select p.product_id, p.name, SUM(oi.quantity) AS total_sold
from Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC;

-- customers who spent the most
SELECT c.customer_id, c.name,
       SUM(oi.quantity * p.price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- revenue per month
-- tried this first but TO_CHAR format was wrong
-- select TO_CHAR(o.order_date, 'Month') AS month, SUM(oi.quantity * p.price) from Orders o, Order_Items oi, Products p where o.order_id = oi.order_id and oi.product_id = p.product_id group by TO_CHAR(o.order_date, 'Month');
SELECT TO_CHAR(o.order_date, 'YYYY-MM') AS month,
       SUM(oi.quantity * p.price) AS revenue
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY month;

-- sales per category
SELECT p.category,
       SUM(oi.quantity * p.price) AS total_sales
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

-- customers who never ordered anything
SELECT c.customer_id, c.name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE 1=1 AND o.order_id IS NULL;

-- repeat buyers
SELECT customer_id, COUNT(order_id) AS cnt
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;