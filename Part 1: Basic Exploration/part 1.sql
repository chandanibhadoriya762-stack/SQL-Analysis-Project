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
