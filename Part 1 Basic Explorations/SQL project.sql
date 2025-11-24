create database classicmodels;
use classicmodels;
select * from customers;
select * from employees;
select * from offices;
select * from orderdetails;
select * from orders;
select * from payments;
select * from productlines;
select * from products;

# part 1:Basic Exploration
# 1] list all customer from USA.
select * from customers
where country="USA";
# 2] show all products where stock is less than 500 units.
select * from products
where quantityInStock<500;
# 3] Find employees working in the paris office
select * from offices
where city="Paris";
# 4] Get orders with status='Cancelled'.
select* from orders
where status="Cancelled";
# 5] list all customers whose credit limit>100000.
select * from customers
where creditLimit>100000;
# 6] Find customers who have no assigned sales representative.
SELECT customerNumber, customerName
FROM Customers
WHERE salesRepEmployeeNumber IS NULL;
# 7] Show all orders placed in 2004
select* from orders
where  YEAR(orderDate) = 2004;

# Part 2: Joins Practice
# 1] Show all orders along with the customer name.
select orderNumber, customerName from customers 
join orders on customers.customerNumber=orders.customerNumber;
# 2] Show each customer with their sales representative’s name.
SELECT c.customerName, 
CONCAT(e.firstName, ' ', e.lastName) AS SalesRepName
FROM customers c JOIN employees e 
ON c.salesRepEmployeeNumber = e.employeeNumber;
# 3] Find all employees and the office city they work in.
select firstName,lastName,city
from employees join offices on employees.officeCode=offices.officeCode;
# 4] Show each order with its ordered products and quantities.
select orderNumber,quantityordered,productName 
from orderdetails join products on orderdetails.productCode=products.productCode;
# 5] List all payments with customer name and country.
select checkNumber,paymentDate,amount,customerName,country
from customers join payments on customers.customerNumber=payments.customerNumber;
# 6] Show all customers who have never placed an order.
SELECT customerName FROM customers 
left JOIN orders ON customers.customerNumber = orders.customerNumber
WHERE orderNumber IS NULL;
# 7] Find employees who don’t manage anyone.
SELECT e.employeeNumber, e.firstName, e.lastName, e.jobTitle
FROM employees e
LEFT JOIN employees m 
       ON e.employeeNumber = m.reportsTo
WHERE m.reportsTo IS NULL;

# Part 3: Aggregates & Grouping
# 1] Count how many customers each country has
SELECT Country, COUNT(CustomerName) AS Total_Customers
FROM Customers
GROUP BY Country
ORDER BY Total_Customers DESC;
# 2] Find the total sales amount for each customer.
SELECT o.customerNumber,SUM(od.quantityOrdered * od.priceEach) AS Total_Sales
FROM Orders o JOIN OrderDetails od ON o.orderNumber = od.orderNumber
GROUP BY o.customerNumber
ORDER BY Total_Sales DESC;
# 3] Show the average credit limit per country.
select country,round(avg(creditLimit),2)as credits_limits
from customers
group by country 
order by credits_limits desc ;
# 4] Find the maximum payment amount per customer.
select customerNumber, max(amount) as maximum_amount
 from payments
 group by customerNumber
 order by maximum_amount;
 # 5] Count the number of products in each product line.
SELECT 
    productLine, 
    COUNT(productCode) AS Total_Products
FROM Products
GROUP BY productLine;
# 6] Find which employee manages the most customers.
select salesRepEmployeeNumber,count(customerNumber)as total_customers
from customers 
group by salesRepEmployeeNumber;
# 7] Get the monthly sales totals for 2004.
SELECT 
    YEAR(o.orderDate) AS orderYear,
    MONTH(o.orderDate) AS orderMonth,
    SUM(od.quantityOrdered * od.priceEach) AS monthlySales
FROM orders o JOIN orderdetails od ON o.orderNumber = od.orderNumber
WHERE YEAR(o.orderDate) = 2004
GROUP BY YEAR(o.orderDate), MONTH(o.orderDate)
ORDER BY orderMonth;
# 8] Find the top 5 customers by total payments
select*from payments;
select customerNumber,round(max(amount))as total_pay from payments 
group by customerNumber 
order by total_pay desc
limit 5;

# Part 4: Subqueries & Insights
# 1] Find customers who made payments greater than the average payment.
select customerNumber,amount
from payments
where amount >(select avg(amount) from payments);
#2] List products that have never been ordered.
select  productcode,productLine from 
products 
where productcode not in(select productcode from orderdetails);
# 3] Find the employee with the highest number of direct reports.
select employeeNumber,count(reportsTo) as highest_number
from employees group by employeeNumber
order by highest_number desc;
# 4] Show orders that contain the most expensive product.
SELECT o.orderNumber, p.productName, p.buyPrice
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
WHERE p.buyPrice = (SELECT MAX(buyPrice) FROM products);
# 5]offices List the top 3 offices with the highest total sales.
select orderNumber,round((quantityOrdered*priceEach))as sales
from orderdetails
order by sales desc 
limit 3;

#  Part 5: Stored Procedures
# 1] Create a procedure to get all orders by a given customer.
DELIMITER $$
CREATE PROCEDURE GetOrdersByCustomer(IN cust_id INT)
BEGIN
    SELECT orderNumber, orderDate, status
    FROM orders
    WHERE customerNumber = cust_id;
END $$
DELIMITER ;
CALL GetOrdersByCustomer(103);
# 2] Create a procedure to find total sales between two dates.
DELIMITER $$
CREATE PROCEDURE TotalSalesBetweenDates(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT SUM(quantityOrdered * priceEach) AS Total_Sales
    FROM orderdetails od
    JOIN orders o ON od.orderNumber = o.orderNumber
    WHERE o.orderDate BETWEEN start_date AND end_date;
END $$
DELIMITER ;
CALL TotalSalesBetweenDates('2004-01-01', '2004-12-31');
# 3] Build a procedure that shows the best-selling product line.
DELIMITER $$
CREATE PROCEDURE BestSellingProductLine()
BEGIN
    SELECT p.productLine, SUM(od.quantityOrdered) AS Total_Sold
    FROM orderdetails od
    JOIN products p ON od.productCode = p.productCode
    GROUP BY p.productLine
    ORDER BY Total_Sold DESC
    LIMIT 1;
END $$
DELIMITER ;
CALL BestSellingProductLine();
#  4]Create a procedure to display all customers handled by an employee.
DELIMITER $$
CREATE PROCEDURE CustomersByEmployee(IN emp_id INT)
BEGIN
    SELECT c.customerNumber, c.customerName, c.city, c.country
    FROM customers c
    WHERE c.salesRepEmployeeNumber = emp_id;
END $$
DELIMITER ;
CALL CustomersByEmployee(1370);
# 5] Write a procedure to calculate yearly revenue given an input year.
DELIMITER $$
CREATE PROCEDURE YearlyRevenue(IN input_year INT)
BEGIN
    SELECT YEAR(o.orderDate) AS Year, 
           SUM(od.quantityOrdered * od.priceEach) AS Revenue
    FROM orderdetails od
    JOIN orders o ON od.orderNumber = o.orderNumber
    WHERE YEAR(o.orderDate) = input_year
    GROUP BY YEAR(o.orderDate);
END $$
DELIMITER ;
CALL YearlyRevenue(2004);

#  Part 6: Advanced Clauses
# 1] Find customers who placed more than 5 orders.
SELECT c.customerNumber, c.customerName, COUNT(o.orderNumber) AS total_orders
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName
HAVING COUNT(o.orderNumber) > 5;
# 2] List product lines where the average MSRP > 100.
SELECT productLine, AVG(MSRP) AS avg_msrp
FROM products
GROUP BY productLine
HAVING AVG(MSRP) > 100;
# 3] Show employees with more than 3 customers assigned.
SELECT e.employeeNumber, e.firstName, e.lastName, COUNT(c.customerNumber) AS total_customers
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY e.employeeNumber, e.firstName, e.lastName
HAVING COUNT(c.customerNumber) > 3;
# 4] Display orders where the shippedDate is NULL.
SELECT orderNumber, orderDate, requiredDate, status
FROM orders
WHERE shippedDate IS NULL;
# 5] Categorize customers by credit limit: High, Medium, Low.
SELECT customerNumber, customerName, creditLimit,
       CASE
           WHEN creditLimit >= 100000 THEN 'High'
           WHEN creditLimit >= 50000 THEN 'Medium'
           ELSE 'Low'
       END AS CreditCategory
FROM customers;
# 6] Find the top 10 most ordered products.
SELECT p.productCode, p.productName, SUM(od.quantityOrdered) AS total_ordered
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productCode, p.productName
ORDER BY total_ordered DESC
LIMIT 10;
# 7] Show the revenue contribution % of each product line.
SELECT p.productLine,
       ROUND(SUM(od.quantityOrdered * od.priceEach) * 100.0 /
            (SELECT SUM(od2.quantityOrdered * od2.priceEach)
             FROM orderdetails od2), 2) AS revenue_percent
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productLine
ORDER BY revenue_percent DESC;







































