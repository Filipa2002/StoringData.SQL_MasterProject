-- Select dataset to run query
USE GourmetTreats;

-- View to get customer details and order summary
CREATE VIEW CustomerDetailsView AS
SELECT
    o.OrderID,
    o.CustomerID,
    o.OrderDate,
    c.FirstName,
    c.LastName,
    c.Email,
    o.TotalAmount
FROM
    Orders o
JOIN
    Customers c ON o.CustomerID = c.CustomerID;

-- View to get product details for each order
CREATE VIEW InvoiceDetailsView AS
SELECT
    od.OrderID,
    od.ProductID,
    p.ProductName,
    od.Quantity,
    od.Subtotal
FROM
    OrderDetails od
JOIN
    Products p ON od.ProductID = p.ProductID;

SELECT
    c.CustomerName,
    c.CustomerEmail,
    c.OrderID,
    c.OrderDate,
    c.TotalAmount,
    iv.ProductName,
    iv.Quantity,
    iv.Subtotal,
    (SELECT SUM(Subtotal) FROM InvoiceDetailsView ivd WHERE ivd.OrderID = c.OrderID) AS TotalInvoiceAmount
FROM
    CustomerDetailsView c
JOIN
    InvoiceDetailsView iv ON c.OrderID = iv.OrderID
WHERE
    c.OrderID = 5; -- Example order ID, replace with dynamic ID or parameter

