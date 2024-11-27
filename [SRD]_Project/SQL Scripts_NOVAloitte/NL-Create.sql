-- Step 1: Create Database
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