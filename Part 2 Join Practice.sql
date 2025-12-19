USE classicmodels;
# Part 2: JOIN Practice 

#1.Show all orders along with the customer name.
SELECT c.customerName,c.contactFirstName,o.status,o.orderDate,p.productName
FROM customers c INNER JOIN orders o
ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od
ON  o.orderNumber = od.orderNumber
INNER JOIN products p
ON od.productCode = p.productCode;

#2.Show each customer with their sales representative’s name.
SELECT c.customerName,concat(e.firstName,' ',e.lastName) AS Sales_Representative_name
FROM  customers c INNER JOIN
employees e ON e.employeeNumber = c.salesRepEmployeeNumber;

#3. Find all employees and the office city they work in.
SELECT e.employeeNumber,concat(e.firstName,' ',e.lastName) AS Employee_Name ,o.city
FROM employees e INNER JOIN offices o
ON e.officeCode = o.officeCode;

#4.Show each order with its ordered products and quantities.
SELECT o.orderNumber,p.productName,od.quantityOrdered
FROM orders o INNER JOIN orderdetails od
ON o.orderNumber = od.orderNumber INNER JOIN
products p ON od.productCode = p.productCode;

#5.List all payments with customer name and country.
SELECT c.customerName,c.country,p.amount 
FROM customers c INNER JOIN
payments p ON c.customerNumber = p.customerNumber;

#6.Show all customers who have never placed an order.
SELECT c.customerName, c.customerNumber
FROM customers c LEFT JOIN
orders o ON o.customerNumber = c.customerNumber
WHERE c.customerNumber NOT IN (SELECT 
customerNumber FROM orders);

#7.Find employees who don’t manage anyone.

SELECT e.employeeNumber FROM customers  ; 