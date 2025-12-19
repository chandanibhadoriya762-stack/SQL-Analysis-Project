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

# Part 1: Basic Exploration

#1. List all Customers from USA.
SELECT customerName,customerNumber,country
 FROM customers WHERE country ='USA';
 
#2. Show all products where stock is less than 500 units.
SELECT productcode,productName,quantityInStock
FROMproducts
WHERE quantityInStock <= 500;

#3.Find employees working in the Paris office.
SELECT e.firstName, e.lastName, o.city
FROM employees e INNER JOIN
offices o ON e.officeCode = o.officeCode
WHERE city = 'Paris';

#4. Get orders with status = 'Cancelled'.
SELECT orderNumber, status
FROM orders WHERE status = 'Cancelled';

#5.List all customers whose credit limit > 100000.
SELECT customerName,contactFirstName,creditLimit
FROM customers WHERE creditLimit > 100000
ORDER BY creditLimit DESC;

#6.Find customers who have no assigned sales representative.
SELECT CustomerNumber,CustomerName
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

#7.Show all orders placed in 2004.
SELECT orderNumber FROM orders WHERE orderDate =2004;