-- Database to run the SQL commands in
USE GourmetTreats;

DELIMITER $$

CREATE TRIGGER before_order_insert
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE log_message VARCHAR(255);
    SET log_message = CONCAT('Order Created, OrderID: ', NEW.OrderID, ', CustomerID: ', NEW.CustomerID);
    
    -- Insert into Logs table
    INSERT INTO Logs (LogDate, Action, Details)
    VALUES (NOW(), 'Order Created', log_message);
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER before_orderdetails_insert
BEFORE INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    
    -- Get the current stock for the product being ordered
    SELECT StockQuantity INTO current_stock FROM Products WHERE ProductID = NEW.ProductID;
    
    -- Update stock quantity in Products table (decrease by the quantity ordered)
    UPDATE Products
    SET StockQuantity = current_stock - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
    
    -- Optionally, you can log the stock update in the Logs table:
    INSERT INTO Logs (LogDate, Action, Details)
    VALUES (NOW(), 'Stock Updated', CONCAT('ProductID: ', NEW.ProductID, ', New Stock: ', current_stock - NEW.Quantity));
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER before_orderdetails_update
BEFORE UPDATE ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE old_stock INT;
    DECLARE new_stock INT;
    
    -- Get the old stock for the product being updated
    SELECT StockQuantity INTO old_stock FROM Products WHERE ProductID = OLD.ProductID;
    
    -- Get the new stock based on the updated quantity
    SELECT StockQuantity INTO new_stock FROM Products WHERE ProductID = NEW.ProductID;
    
    -- Update the product's stock (revert the old quantity and apply the new one)
    UPDATE Products
    SET StockQuantity = old_stock + OLD.Quantity - NEW.Quantity
    WHERE ProductID = OLD.ProductID;
    
    -- Optionally, log the stock update
    INSERT INTO Logs (LogDate, Action, Details)
    VALUES (NOW(), 'Stock Updated', CONCAT('ProductID: ', OLD.ProductID, ', New Stock: ', old_stock + OLD.Quantity - NEW.Quantity));
END $$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER after_orderdetails_insert
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE order_total DECIMAL(10, 2);
    
    -- Calculate the new total for the order after inserting the order details
    SELECT SUM(Subtotal) INTO order_total
    FROM OrderDetails
    WHERE OrderID = NEW.OrderID;
    
    -- Update the total amount in the Orders table
    UPDATE Orders
    SET TotalAmount = order_total
    WHERE OrderID = NEW.OrderID;
    
    -- Optionally, log this update in the Logs table
    INSERT INTO Logs (LogDate, Action, Details)
    VALUES (NOW(), 'Order Total Updated', CONCAT('OrderID: ', NEW.OrderID, ', New TotalAmount: ', order_total));
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER before_orderdetails_delete
BEFORE DELETE ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    
    -- Get the current stock of the product being deleted from the order
    SELECT StockQuantity INTO current_stock FROM Products WHERE ProductID = OLD.ProductID;
    
    -- Revert stock quantity
    UPDATE Products
    SET StockQuantity = current_stock + OLD.Quantity
    WHERE ProductID = OLD.ProductID;
    
    -- Optionally, log the stock update
    INSERT INTO Logs (LogDate, Action, Details)
    VALUES (NOW(), 'Stock Updated', CONCAT('ProductID: ', OLD.ProductID, ', New Stock: ', current_stock + OLD.Quantity));
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER after_order_delete
AFTER DELETE ON Orders
FOR EACH ROW
BEGIN
    -- Log the deletion of the order in the Logs table
    INSERT INTO Logs (LogDate, Action, Details)
    VALUES (NOW(), 'Order Deleted', CONCAT('OrderID: ', OLD.OrderID, ', CustomerID: ', OLD.CustomerID));
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER before_product_insert
BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
    IF NEW.StockQuantity < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock quantity cannot be negative';
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_product_update
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.Price != NEW.Price THEN
        -- Log the price change in the Logs table
        INSERT INTO Logs (LogDate, Action, Details)
        VALUES (NOW(), 'Product Price Updated', CONCAT('ProductID: ', NEW.ProductID, ', Old Price: ', OLD.Price, ', New Price: ', NEW.Price));
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_log_insert
AFTER INSERT ON Logs
FOR EACH ROW
BEGIN
    -- You can add some action here if needed, like notifying someone or logging elsewhere.
    -- This is just a simple trigger that doesn't do much in this case.
    -- Example: You can notify via email or add a timestamp field.
END $$

DELIMITER ;


-- Suppliers
INSERT INTO Suppliers (SupplierName, ContactName, Phone, Address) VALUES
('Honey Bee Co.', 'Alice Brown', '1231231234', '123 Honey Street, London, UK'),
('Artisan Cheeses', 'Bob Green', '9879879876', 'Central Market, Paris, France'),
('Exotic Spices Ltd.', 'Carla White', '4564564567', 'Spice Bazaar, Mumbai'),
('Green Pastures Dairy', 'James O’Hara', '5551234567', 'Rural Route 5, Galway, Ireland'),
('Far East Importers', 'Sakura Tanaka', '7894561230', 'Harbor District, Osaka, Japan');

-- Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, RegistrationDate) VALUES
('John', 'Doe', 'johnny_d123@gmail.com', '1234567890', '2023-01-15'),
('Jane', 'Smith', 'janesmith@email.com', '9876543210', '2023-02-20'),
('Aisha', 'Khan', 'a.khan@nomail.com', '', '2023-03-10'),
('Mario', 'Rossi', 'm.rossi@mail.it', '7891234560', '2023-11-01'),
('Liam', 'O’Connor', '', '8181818181', '2021-06-25'),
('Sophia', 'Nguyen', 'sofia.nguyen+shopper@example.com', '1111111111', '2023-08-08'),
('Carlos', 'Ramirez', 'ramirez.carlos@example.com', '2222222222', '2023-09-25'),
('Hana', 'Yamada', 'hana.yamada@example.co.jp', '', '2023-10-11'),
('Olivia', 'Martinez', 'olivia.martinez@outlook.com', '3334445555', '2023-11-15'),
('Luke', 'Wilson', 'luke_wilson@gmail.com', '6667778888', '2023-07-18');


-- Products
INSERT INTO Products (ProductName, Description, Price, Stock, SupplierID) VALUES
('Organic Honey – 250g', 'Pure organic honey, small jar.', 8.50, 15, 1),
('Organic Honey – 1kg', 'Bulk organic honey, family size.', 25.00, 5, 1),
('Aged Gouda Cheese', 'Dutch-style cheese, matured 18 months.', 22.00, 45, 2),
('Cinnamon Sticks – Premium', 'Top-grade, aromatic cinnamon sticks.', 9.50, 50, 3),
('Cinnamon Sticks – Regular', 'Everyday cooking quality.', 5.00, 120, 3),
('Infused Truffle Oil', 'Truffle oil blended with herbs.', 15.00, 0, 3),
('Natural Honeycomb – 500g', 'Harvested honeycomb from wildflowers.', 20.00, 25, 1),
('Basil Pesto – 200g', 'Classic basil pesto with pine nuts.', 6.75, 100, 4),
('Mozzarella Cheese – 500g', 'Fresh mozzarella made from cow’s milk.', 12.00, 60, 2),
('Thai Chili Sauce – 150ml', 'Spicy and tangy chili sauce, perfect for Asian dishes.', 4.25, 80, 5),
('Lemon Zest Olive Oil – 250ml', 'Olive oil infused with fresh lemon zest.', 14.50, 30, 5);

-- Orders 
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(3, '2023-11-17', 22.00),
(5, '2023-12-24', 150.50),
(7, '2023-11-25', 0.00),
(9, '2023-01-15', 89.00),
(10, '2023-10-31', 65.00),
(1, '2023-05-01', 15.00),
(6, '2022-11-25', 500.00),
(4, '2023-11-22', 20.00), -- Small order
(2, '2023-10-15', 95.00), -- Medium order
(8, '2023-12-05', 250.00), -- Bulk purchase
(1, '2023-08-21', 60.00),
(9, '2023-07-30', 35.75),
(6, '2023-09-02', 112.50),
(9, '2023-11-10', 200.00),
(1, '2023-12-20', 110.75),
(2, '2023-12-22', 40.00),
(3, '2023-12-18', 210.50),
(4, '2023-12-10', 75.25),
(5, '2023-12-25', 185.50),
(6, '2023-12-14', 65.75),
(7, '2023-12-21', 95.00),
(8, '2023-12-23', 120.00),
(9, '2023-12-19', 49.90),
(10, '2023-12-16', 220.30);


-- OrderDetails 
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Subtotal) VALUES
(1, 1, 2, 17.00),  -- Valid OrderID and ProductID
(2, 4, 1, 15.00),  -- Valid OrderID and ProductID
(3, 3, 6, 28.50),  -- Valid OrderID and ProductID
(4, 5, 4, 60.00),  -- Valid OrderID and ProductID
(5, 6, 1, 25.00),  -- Valid OrderID and ProductID
(6, 2, 12, 132.00),  -- Valid OrderID and ProductID
(7, 1, 1, 8.50),  -- Simple order with productID 1
(8, 4, 1, 9.50),  -- Product from Order 8
(9, 5, 3, 15.00),  -- Order 9, product 5
(10, 3, 5, 27.50),  -- Order 10, product 3
(1, 1, 1, 8.50),  -- Single product
(2, 3, 1, 22.00),  -- Single product
(3, 2, 3, 66.00),  -- Bulk mozzarella
(4, 6, 1, 15.00),  -- Add product 6orders
(5, 7, 5, 100.00),  -- Extra honeycomb
(6, 8, 4, 27.00),  -- Pesto product
(7, 9, 7, 29.75),  -- Chili sauce product
(8, 10, 3, 43.50),  -- Lemon zest product
(9, 2, 6, 90.00),  -- Bulk cheese
(10, 5, 3, 15.00),  -- Cinnamon sticks
(1, 6, 4, 52.00),  -- Order for 4 of product 6
(2, 7, 3, 45.00),  -- Order for 3 of product 7
(3, 8, 2, 32.50),  -- Order for 2 of product 8
(4, 9, 6, 72.00),  -- 6 items of product 9
(5, 10, 7, 72.00);  -- Order 5, product 10



-- Ratings
INSERT INTO Ratings (CustomerID, ProductID, RatingValue, RatingDate, Comment) VALUES
(2, 1, 2, '2023-01-10', 'The honey tasted fine, but the jar was leaking.'),
(6, 3, 5, '2023-03-11', 'This is my go-to spice. Amazing aroma every time!'),
(9, 5, 3, '2023-05-09', 'Decent honeycomb, but I found it overpriced.'),
(8, 4, 4, '2023-07-13', 'Great oil, though the bottle design could improve.'),
(11, 1, 1, '2023-11-02', 'Not satisfied, the honey didn’t taste fresh.'),
(4, 2, 5, '2023-12-24', 'This cheese was a hit at our Christmas dinner!'),
(5, 3, 5, '2023-10-01', 'Perfect spice mix, can’t get enough of it.'),
(7, 6, 4, '2023-09-17', 'Great truffle oil, but I wish it was cheaper.'),
(1, 6, 5, '2023-12-21', 'Still the best honey on the market!'),
(2, 7, 4, '2023-12-22', 'Very good cheese, but a bit expensive.'),
(3, 8, 3, '2023-12-20', 'Decent cinnamon, a little too bitter for my taste.'),
(4, 9, 5, '2023-12-19', 'Truffle oils are fantastic, my cooking has improved!'),
(5, 10, 5, '2023-12-23', 'I love the honeycomb, tastes so fresh.'),
(6, 6, 4, '2023-12-25', 'Good quality honey, could be sweeter though.'),
(7, 7, 5, '2023-12-24', 'Gourmet cheddar is always a hit, perfect for parties.'),
(8, 8, 4, '2023-12-23', 'Great cinnamon sticks for baking.'),
(9, 9, 5, '2023-12-22', 'I’ve never tasted anything like this truffle oil!'),
(10, 10, 4, '2023-12-21', 'Honeycomb is great, would buy again.'),
(1, 6, 5, '2023-12-20', 'Honey still tastes amazing, very smooth.'),
(2, 7, 4, '2023-12-21', 'Great cheese, perfect texture but a little pricey.'),
(3, 8, 3, '2023-12-19', 'Okay, but could have been fresher.'),
(4, 9, 5, '2023-12-18', 'This truffle oil is now a staple in my kitchen!'),
(5, 10, 5, '2023-12-17', 'Best honeycomb I’ve had in a long time!'),
(6, 6, 4, '2023-12-16', 'Good, but I’ve had better honey.'),
(7, 7, 5, '2023-12-15', 'The best cheddar, perfect for a cheese platter!'),
(8, 8, 4, '2023-12-14', 'I love using these cinnamon sticks in my tea.'),
(9, 9, 5, '2023-12-13', 'Truffle oil makes any dish gourmet, worth every penny.'),
(10, 10, 3, '2023-12-12', 'Honeycomb was okay, wasn’t as fresh as expected.');

-- Insert Records into Employees
INSERT INTO Employees (FirstName, LastName, Email, Phone, HireDate) VALUES
('Alice', 'Williams', 'alice.williams@example.com', '1234567890', '2022-01-10'),
('Bob', 'Johnson', 'bob.johnson@example.com', '0987654321', '2021-05-20'),
('Carol', 'Smith', 'carol.smith@example.com', '4561237890', '2023-03-15');

-- Insert Records into EmployeeRoles
INSERT INTO EmployeeRoles (RoleName, EmployeeID) VALUES
('Manager', 1),
('Sales Representative', 2),
('Warehouse Staff', 3);

-- Updated Log Entries
INSERT INTO Logs (LogDate, Action, Details) VALUES
('2023-11-15 14:00:00', 'Order Created', 'OrderID: 1, CustomerID: 3, TotalAmount: 22.00'),
('2023-11-16 15:30:00', 'Stock Updated', 'ProductID: 5, New Stock: 50'),
('2023-11-17 16:00:00', 'Order Cancelled', 'OrderID: 7, CustomerID: 6, Reason: Payment Failed'),
('2023-12-01 09:00:00', 'Order Shipped', 'OrderID: 12, CustomerID: 4, TotalAmount: 75.25'),
('2023-12-03 11:15:00', 'Stock Updated', 'ProductID: 4, New Stock: 150'),
('2023-12-07 13:45:00', 'Order Shipped', 'OrderID: 14, CustomerID: 7, TotalAmount: 100.00'),
('2023-12-10 17:00:00', 'Discount Applied', 'OrderID: 5, CustomerID: 6, Discount: 15% for seasonal sale'),
('2023-12-12 14:10:00', 'Payment Failed', 'OrderID: 10, CustomerID: 1, Reason: Invalid card'),
('2023-12-15 10:25:00', 'Stock Updated', 'ProductID: 3, New Stock: 100'),
('2023-11-10 08:00:00', 'Order Created', 'OrderID: 13, CustomerID: 3, TotalAmount: 210.50'),
('2023-11-11 08:45:00', 'Stock Updated', 'ProductID: 7, New Stock: 30'),
('2023-12-20 13:00:00', 'Order Created', 'OrderID: 30, CustomerID: 1, TotalAmount: 110.75'),
('2023-12-21 14:30:00', 'Order Created', 'OrderID: 31, CustomerID: 2, TotalAmount: 95.00'),
('2023-12-22 15:45:00', 'Order Created', 'OrderID: 32, CustomerID: 3, TotalAmount: 66.00'),
('2023-12-23 16:00:00', 'Order Created', 'OrderID: 33, CustomerID: 4, TotalAmount: 72.00'),
('2023-12-24 17:15:00', 'Order Created', 'OrderID: 34, CustomerID: 5, TotalAmount: 185.50'),
('2023-12-25 18:00:00', 'Order Created', 'OrderID: 35, CustomerID: 6, TotalAmount: 150.00'),
('2023-12-26 10:30:00', 'Order Created', 'OrderID: 36, CustomerID: 7, TotalAmount: 200.00'),
('2023-12-27 11:00:00', 'Order Created', 'OrderID: 37, CustomerID: 8, TotalAmount: 95.00'),
('2023-12-28 12:15:00', 'Order Created', 'OrderID: 38, CustomerID: 9, TotalAmount: 49.90'),
('2023-12-29 13:00:00', 'Order Created', 'OrderID: 39, CustomerID: 10, TotalAmount: 220.30'),
('2023-12-30 14:00:00', 'Order Created', 'OrderID: 40, CustomerID: 1, TotalAmount: 15.00'),
('2023-12-31 15:30:00', 'Order Created', 'OrderID: 41, CustomerID: 2, TotalAmount: 95.00'),
('2024-01-01 16:00:00', 'Order Created', 'OrderID: 42, CustomerID: 3, TotalAmount: 28.50'),
('2024-01-02 17:15:00', 'Order Created', 'OrderID: 43, CustomerID: 4, TotalAmount: 60.00'),
('2024-01-03 18:30:00', 'Order Created', 'OrderID: 44, CustomerID: 5, TotalAmount: 100.00'),
('2024-01-04 19:00:00', 'Order Created', 'OrderID: 45, CustomerID: 6, TotalAmount: 150.50'),
('2024-01-05 10:30:00', 'Order Created', 'OrderID: 46, CustomerID: 7, TotalAmount: 200.00'),
('2024-01-06 11:15:00', 'Order Created', 'OrderID: 47, CustomerID: 8, TotalAmount: 45.00'),
('2024-01-07 12:00:00', 'Order Created', 'OrderID: 48, CustomerID: 9, TotalAmount: 32.50'),
('2024-01-08 13:45:00', 'Order Created', 'OrderID: 49, CustomerID: 10, TotalAmount: 43.50'),
('2024-01-09 14:30:00', 'Order Created', 'OrderID: 50, CustomerID: 1, TotalAmount: 89.00');

