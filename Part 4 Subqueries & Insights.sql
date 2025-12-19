USE classicModels;
# Part 4: Subqueries & Insights

# 1. Find customers who made payments greater than the average payment.
SELECT c.customerName, c.customerNumber, round(p.amount) AS "More_than_AVG"
FROM customers c INNER JOIN payments p ON c.customerNumber = p.customerNumber
WHERE p.amount > (SELECT AVG(amount) FROM payments);

# 2 List products that have never been ordered.
SELECT p.productCode, p.productName
FROM orderdetails o RIGHT JOIN products p ON p.productCode = o.productCode
WHERE p.productCode NOT IN (SELECT productCode FROM orderdetails);

# 3. Find the employee with the highest number of direct reports.
SELECT 
e.employeeNumber,e.firstName,e.lastName,e.reportsTo,
COUNT(r.employeeNumber) AS Direct_report_to
FROM employees e LEFT JOIN
employees r ON e.employeeNumber = r.reportsTo
GROUP BY e.employeeNumber , e.firstName , e.lastName
ORDER BY Direct_report_to DESC
LIMIT 5;

# 4. Show orders that contain the most expensive product.
SELECT DISTINCT p.productCode, p.productName, p.MSRP
FROM orderdetails o JOIN products p ON p.productCode = o.productCode
ORDER BY MSRP DESC;

# 5. List the top 3 offices with the highest total sales.
SELECT 
o.officeCode,o.city,o.country,
SUM(p.amount) AS Total_sales
FROM offices o JOIN employees e ON o.officeCode = e.officeCode JOIN
customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY o.officeCode , o.city , o.country
ORDER BY Total_sales DESC;