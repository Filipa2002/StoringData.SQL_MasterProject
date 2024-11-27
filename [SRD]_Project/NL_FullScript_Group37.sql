-- Step 1: Create Database

DROP DATABASE IF EXISTS NOVAloitteDB;
CREATE DATABASE IF NOT EXISTS NOVAloitteDB;
USE NOVAloitteDB;

-- Clients Table
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Address VARCHAR(255),
    Industry VARCHAR(100),
    ClientSince DATE
);

-- Projects Table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY AUTO_INCREMENT,
    ClientID INT,
    ProjectName VARCHAR(255),
    Description TEXT,
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(50),
    Budget DECIMAL(10, 2),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Position VARCHAR(100),
    HireDate DATE,
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Salary DECIMAL(10, 2)
);

-- ProjectConsultants Table
CREATE TABLE ProjectConsultants (
    ProjectConsultantID INT PRIMARY KEY AUTO_INCREMENT,
    ProjectID INT,
    EmployeeID INT,
    Role VARCHAR(100),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- CollectedData Table
CREATE TABLE CollectedData (
    DataID INT PRIMARY KEY AUTO_INCREMENT,
    ProjectID INT,
    DataType VARCHAR(100),
    Format VARCHAR(50),
    CollectionDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Reports Table
CREATE TABLE Reports (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,
    ProjectID INT,
    ReportTitle VARCHAR(255),
    ReportDate DATE,
    ReportStatus VARCHAR(50),
    ReportContent TEXT,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Contracts Table
CREATE TABLE Contracts (
    ContractID INT PRIMARY KEY AUTO_INCREMENT,
    ClientID INT,
    ProjectID INT,
    ContractDate DATE,
    StartDate DATE,
    EndDate DATE,
    TotalValue DECIMAL(10, 2),
    Terms TEXT,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Invoices Table
CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY AUTO_INCREMENT,
    ContractID INT,
    IssueDate DATE,
    DueDate DATE,
    Amount DECIMAL(10, 2),
    PaidAmount DECIMAL(10, 2),
    Status VARCHAR(50),
    FOREIGN KEY (ContractID) REFERENCES Contracts(ContractID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Logs Table
CREATE TABLE Logs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    Action VARCHAR(255),
    Description TEXT,
    Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Employees(EmployeeID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- ############################################################################################################

-- Step 2: Insert Data

-- Insert Data into Clients
INSERT INTO Clients (CompanyName, ContactName, Email, Phone, Address, Industry, ClientSince)
VALUES
('Tech Innovations', 'Alice Smith', 'alice.smith@techinnovations.com', '123-456-7890', '123 Silicon Valley, CA', 'Technology', '2015-06-01'),
('Green Solutions', 'John Doe', 'john.doe@greensolutions.com', '123-987-6543', '456 Greenway St, FL', 'Environmental', '2018-03-15'),
('EcoEnergy Co.', 'Maria Gonzalez', 'maria@ecoenergy.com', '321-654-9870', '789 Solar Ave, TX', 'Energy', '2019-01-21'),
('Retail Pro', 'James Lee', 'james@retailpro.com', '654-321-4567', '123 Commerce St, NY', 'Retail', '2017-11-11'),
('Alpha Industries', 'Rachel Adams', 'rachel@alphaindustries.com', '543-210-7654', '234 Industrial Rd, NV', 'Manufacturing', '2020-02-20'),
('HealthMax', 'Robert Davis', 'robert@healthmax.com', '432-567-8901', '345 Wellness Blvd, NJ', 'Healthcare', '2016-08-04'),
('FinTech Solutions', 'Evelyn Clark', 'evelyn@fintechsolutions.com', '789-123-4560', '456 Finance St, NY', 'Finance', '2021-10-05'),
('Urban Living', 'Michael Brown', 'michael@urbanliving.com', '321-987-6543', '567 Modern Ave, CA', 'Real Estate', '2022-06-18'),
('NextGen Foods', 'Sophia White', 'sophia@nextgenfoods.com', '321-654-9876', '678 Organic Rd, OR', 'Food', '2014-07-13'),
('BlueWave Tech', 'Daniel Johnson', 'daniel@bluewavetech.com', '654-321-0987', '789 Technology Park, MA', 'Technology', '2020-05-10');

-- Insert Data into Projects
INSERT INTO Projects (ClientID, ProjectName, Description, StartDate, EndDate, Status, Budget)
VALUES
(1, 'AI Automation', 'Developing AI automation tools for clients in the tech industry', '2023-01-15', '2023-12-01', 'Active', 50000),
(2, 'Solar Panel Deployment', 'Installation of solar panels across five states', '2023-02-20', '2024-06-01', 'Active', 100000),
(3, 'Wind Energy Project', 'Building wind turbines to support clean energy', '2022-10-10', '2023-11-30', 'Completed', 75000),
(4, 'Retail Store Expansion', 'Expanding 50 retail stores nationwide', '2023-04-05', '2024-02-28', 'Active', 120000),
(5, 'Manufacturing Plant Upgrade', 'Upgrading machines and production lines', '2023-07-01', '2023-12-31', 'Pending', 200000),
(6, 'Health App Development', 'Creating a health app for tracking wellness', '2022-11-01', '2023-06-01', 'Completed', 45000),
(7, 'Blockchain Integration', 'Implementing blockchain technology into financial operations', '2023-03-10', '2023-09-15', 'Completed', 90000),
(8, 'Smart City Infrastructure', 'Building infrastructure for smart cities', '2022-08-15', '2023-11-20', 'Active', 150000),
(9, 'Plant-Based Products Launch', 'Launching a new line of plant-based products', '2023-01-01', '2023-06-30', 'Active', 30000),
(10, 'NextGen AI Software', 'Development of next-generation AI software for enterprise use', '2023-02-01', '2023-08-30', 'Active', 60000);

-- Insert Data into Employees
INSERT INTO Employees (FirstName, LastName, Position, HireDate, Email, Phone, Salary)
VALUES
('Alice', 'Johnson', 'Data Scientist', '2021-06-15', 'alice.johnson@novaloitte.com', '321-654-1230', 80000),
('Bob', 'Smith', 'Project Manager', '2019-08-23', 'bob.smith@novaloitte.com', '432-765-9087', 95000),
('Charlie', 'Brown', 'Consultant', '2020-05-10', 'charlie.brown@novaloitte.com', '543-876-7654', 75000),
('Diana', 'Clark', 'Data Analyst', '2022-03-25', 'diana.clark@novaloitte.com', '654-987-4321', 70000),
('Eve', 'Davis', 'Project Lead', '2021-10-15', 'eve.davis@novaloitte.com', '765-432-9876', 110000),
('Frank', 'Moore', 'Consultant', '2023-01-10', 'frank.moore@novaloitte.com', '876-543-2109', 65000),
('Grace', 'Miller', 'Business Analyst', '2022-06-05', 'grace.miller@novaloitte.com', '987-654-3210', 72000),
('Helen', 'Taylor', 'Client Manager', '2021-12-01', 'helen.taylor@novaloitte.com', '123-321-6540', 85000),
('Ian', 'Williams', 'Consultant', '2019-09-12', 'ian.williams@novaloitte.com', '234-432-7654', 70000),
('Jack', 'Jones', 'Data Scientist', '2020-11-17', 'jack.jones@novaloitte.com', '345-543-8765', 78000);

-- Insert Data into ProjectConsultants
INSERT INTO ProjectConsultants (ProjectID, EmployeeID, Role)
VALUES
(1, 1, 'Lead Data Scientist'),
(1, 2, 'Project Manager'),
(2, 3, 'Consultant'),
(2, 4, 'Data Analyst'),
(3, 5, 'Project Lead'),
(4, 6, 'Consultant'),
(5, 7, 'Business Analyst'),
(6, 8, 'Client Manager'),
(7, 9, 'Consultant'),
(8, 10, 'Data Scientist');

-- Insert Data into CollectedData
INSERT INTO CollectedData (ProjectID, DataType, Format, CollectionDate, Status)
VALUES
(1, 'Sales Data', 'CSV', '2023-01-20', 'Processed'),
(2, 'Solar Panel Efficiency', 'JSON', '2023-03-15', 'Pending'),
(3, 'Wind Speed Data', 'XML', '2022-11-05', 'Processed'),
(4, 'Retail Sales Data', 'CSV', '2023-04-10', 'Processed'),
(5, 'Production Line Efficiency', 'CSV', '2023-07-10', 'Pending'),
(6, 'App Usage Statistics', 'JSON', '2022-11-20', 'Processed'),
(7, 'Blockchain Transactions', 'XML', '2023-04-05', 'Processed'),
(8, 'City Traffic Data', 'CSV', '2022-09-10', 'Pending'),
(9, 'Product Launch Stats', 'JSON', '2023-02-25', 'Processed'),
(10, 'AI Model Training Data', 'CSV', '2023-03-15', 'Pending');

-- Insert Data into Reports
INSERT INTO Reports (ProjectID, ReportTitle, ReportDate, ReportStatus, ReportContent)
VALUES
(1, 'AI Model Training Report', '2023-05-10', 'Completed', 'Detailed report on the training of AI models.'),
(2, 'Solar Panel Deployment Progress', '2023-07-15', 'Active', 'Midway progress report on solar panel installation.'),
(3, 'Wind Energy Project Final Report', '2023-12-01', 'Completed', 'Final report for the wind energy project implementation.'),
(4, 'Retail Expansion Status', '2023-09-10', 'Active', 'Current status of retail store expansion.'),
(5, 'Manufacturing Plant Report', '2023-08-20', 'Pending', 'Report on ongoing manufacturing plant upgrades.'),
(6, 'Health App Beta Testing Report', '2023-04-15', 'Completed', 'Feedback and testing data from health app beta version.'),
(7, 'Blockchain Integration Status', '2023-07-01', 'Completed', 'Summary of blockchain integration into financial operations.'),
(8, 'Smart City Infrastructure Progress', '2023-10-10', 'Active', 'Update on smart city infrastructure project.'),
(9, 'Plant-Based Product Sales Report', '2023-05-01', 'Completed', 'Sales report for newly launched plant-based products.'),
(10, 'AI Software Development Progress', '2023-06-15', 'Active', 'Progress report on AI software development for enterprise.');


-- ############################################################################################################

-- Step 3: Create Triggers

-- Trigger to log whenever a new project is created

-- Change the delimiter to avoid conflicts with ; in the trigger code
DELIMITER //

CREATE TRIGGER ProjectCreateTrigger 
AFTER INSERT ON Projects
FOR EACH ROW
BEGIN
    INSERT INTO Logs (Action, Description, UserID)
    VALUES ('Project Created', CONCAT('New project ', NEW.ProjectName, ' created for client ', NEW.ClientID), 1);
END;

//


-- Trigger to log when an invoice is paid

CREATE TRIGGER InvoicePaidTrigger
AFTER UPDATE ON Invoices
FOR EACH ROW
BEGIN
    IF OLD.Status = 'Pending' AND NEW.Status = 'Paid' THEN
        INSERT INTO Logs (Action, Description, UserID)
        VALUES ('Invoice Paid', CONCAT('Invoice ID ', NEW.InvoiceID, ' has been paid for contract ', NEW.ContractID), 1);
    END IF;
END ;

//


-- Trigger to update the status of the project when it is completed

CREATE TRIGGER UpdateProjectStatusAfterReport
AFTER INSERT ON Reports
FOR EACH ROW
BEGIN
    IF NEW.ReportStatus = 'Final' THEN
        UPDATE Projects
        SET Status = 'Completed'
        WHERE ProjectID = NEW.ProjectID;
    END IF;
END ;

//

-- Reset the delimiter back to ;
DELIMITER ;

-- ============================================================================================================

-- Test Triggers

-- Insert a new project



-- ############################################################################################################

-- Step 4: Create Views

-- View to get all projects along with their client details
CREATE VIEW ProjectDetails AS
SELECT 
    p.ProjectID,
    p.ProjectName,
    p.StartDate,
    p.EndDate,
    p.Status,
    p.Budget,
    c.CompanyName,
    c.ContactName,
    c.Email,
    c.Phone
FROM Projects p
JOIN Clients c ON p.ClientID = c.ClientID;

-- View to get employee roles in each project
CREATE VIEW EmployeeRoles AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    pc.ProjectID,
    pc.Role
FROM Employees e
JOIN ProjectConsultants pc ON e.EmployeeID = pc.EmployeeID;

-- View for all active contracts and their invoices
CREATE VIEW ActiveContractsInvoices AS
SELECT 
    c.ContractID,
    c.StartDate,
    c.EndDate,
    c.TotalValue,
    i.InvoiceID,
    i.IssueDate,
    i.Amount,
    i.PaidAmount,
    i.Status
FROM Contracts c
JOIN Invoices i ON c.ContractID = i.ContractID
WHERE i.Status = 'Pending';

-- View to track collected data for each project
CREATE VIEW CollectedDataSummary AS
SELECT 
    p.ProjectID,
    p.ProjectName,
    cd.DataType,
    COUNT(cd.DataID) AS DataCount
FROM Projects p
JOIN CollectedData cd ON p.ProjectID = cd.ProjectID
GROUP BY p.ProjectID, cd.DataType;

-- ############################################################################################################

-- Step 5: Queries

-- 1. Find the total value of all active projects for each client
SELECT 
    c.CompanyName, 
    SUM(p.Budget) AS TotalBudget
FROM Clients c
JOIN Projects p ON c.ClientID = p.ClientID
WHERE p.Status = 'Active'
GROUP BY c.CompanyName;

-- 2. List all employees working on a project and their roles
SELECT 
    e.FirstName,
    e.LastName,
    pc.Role,
    p.ProjectName
FROM Employees e
JOIN ProjectConsultants pc ON e.EmployeeID = pc.EmployeeID
JOIN Projects p ON pc.ProjectID = p.ProjectID
WHERE p.ProjectID = 1;  -- Replace 1 with the project ID you're interested in

-- 3. Get the invoice details for contracts that are overdue
SELECT 
    c.ContractID, 
    i.InvoiceID, 
    i.Amount, 
    i.DueDate, 
    DATEDIFF(CURDATE(), i.DueDate) AS DaysOverdue
FROM Invoices i
JOIN Contracts c ON i.ContractID = c.ContractID
WHERE i.Status = 'Pending' AND i.DueDate < CURDATE();

-- 4. Get the number of data types collected for each project
SELECT 
    p.ProjectName,
    cd.DataType,
    COUNT(cd.DataID) AS DataCount
FROM CollectedData cd
JOIN Projects p ON cd.ProjectID = p.ProjectID
GROUP BY p.ProjectID, cd.DataType
ORDER BY DataCount DESC;