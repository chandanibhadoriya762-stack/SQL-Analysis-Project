use classicmodels;
# Part 6:Advanced Clauses

# 1. Find customers who placed more than 5 orders
SELECT c.customerNumber,c.customerName,COUNT(o.orderNumber) AS total_orders
FROM customers c JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName
HAVING COUNT(o.orderNumber) > 5;

# 2. List product lines where the average MSRP > 100
SELECT productLine,AVG(MSRP) AS avg_msrp
FROM products GROUP BY productLine
HAVING AVG(MSRP) > 100;

# 3. Show employees with more than 3 customers assigned
SELECT e.employeeNumber,CONCAT(e.firstName, ' ', e.lastName) AS employee_name,
COUNT(c.customerNumber) AS total_customers
FROM employees e JOIN customers c
ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY e.employeeNumber, employee_name
HAVING COUNT(c.customerNumber) > 3;

# 4. Display orders where the shippedDate is NULL
SELECT orderNumber,orderDate,requiredDate,shippedDate,
status FROM orders WHERE shippedDate IS NULL;

# 5. Categorize customers by credit limit (High, Medium, Low)
SELECT customerNumber,customerName,creditLimit,
CASE
	WHEN creditLimit >= 100000 THEN 'High'
	WHEN creditLimit BETWEEN 50000 AND 99999 THEN 'Medium'
	ELSE 'Low'
END AS credit_category FROM customers;

# 6. Find the top 10 most ordered products
SELECT p.productCode,p.productName,SUM(od.quantityOrdered) AS total_quantity
FROM products p JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
ORDER BY total_quantity DESC
LIMIT 10;

# 7. Show the revenue contribution % of each product line
SELECT p.productLine,ROUND(SUM(od.quantityOrdered * od.priceEach) /
(SELECT SUM(quantityOrdered * priceEach) FROM orderdetails) * 100,2) 
AS revenue_percentage FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productLine
ORDER BY revenue_percentage DESC;

