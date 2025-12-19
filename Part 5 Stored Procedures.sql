use Classicmodels;
# Part 5:Stored Procedures

# 1.Create a procedure to get all orders by a given customer.
DELIMITER $$

CREATE PROCEDURE GetOrdersByCustomer (
    IN p_customerNumber INT
)
BEGIN
    SELECT orderNumber,
           orderDate,
           requiredDate,
           shippedDate,
           status
    FROM orders
    WHERE customerNumber = p_customerNumber;
END $$

DELIMITER ;
CALL GetOrdersByCustomer(103);

# 2.create a Procedure to find total sales between two dates
DELIMITER $$

CREATE PROCEDURE GetTotalSalesBetweenDates (
    IN p_startDate DATE,
    IN p_endDate DATE
)
BEGIN
    SELECT 
        SUM(od.quantityOrdered * od.priceEach) AS total_sales
    FROM orders o
    JOIN orderdetails od
        ON o.orderNumber = od.orderNumber
    WHERE o.orderDate BETWEEN p_startDate AND p_endDate;
END $$

DELIMITER ;
CALL GetTotalSalesBetweenDates('2003-01-01', '2003-12-31');

# 3.Build a Procedure to show the best-selling product line

DELIMITER $$

CREATE PROCEDURE GetBestSellingProductLine ()
BEGIN
    SELECT p.productLine,
           SUM(od.quantityOrdered * od.priceEach) AS total_revenue
    FROM products p
    JOIN orderdetails od
        ON p.productCode = od.productCode
    GROUP BY p.productLine
    ORDER BY total_revenue DESC
    LIMIT 1;
END $$

DELIMITER ;
CALL GetBestSellingProductLine();

# 4.create a Procedure to display all customers handled by an employee

DELIMITER $$

CREATE PROCEDURE GetCustomersByEmployee (
    IN p_employeeNumber INT
)
BEGIN
    SELECT customerNumber,
           customerName,
           city,
           country
    FROM customers
    WHERE salesRepEmployeeNumber = p_employeeNumber;
END $$

DELIMITER ;
CALL GetCustomersByEmployee(1370);

# 5.write a Procedure to calculate yearly revenue given an input year

DELIMITER $$

CREATE PROCEDURE GetYearlyRevenue (
    IN p_year INT
)
BEGIN
    SELECT 
        p_year AS year,
        SUM(od.quantityOrdered * od.priceEach) AS yearly_revenue
    FROM orders o
    JOIN orderdetails od
        ON o.orderNumber = od.orderNumber
    WHERE YEAR(o.orderDate) = p_year;
END $$

DELIMITER ;
CALL GetYearlyRevenue(2004);
