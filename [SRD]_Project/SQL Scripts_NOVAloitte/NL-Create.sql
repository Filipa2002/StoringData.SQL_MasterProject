-- Create Database for our business 
CREATE DATABASE IF NOT EXISTS NOVAloitteDB;
USE NOVAloitteDB;

-- Locations Table 
CREATE TABLE Locations (
    LocationID INT PRIMARY KEY AUTO_INCREMENT,
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100)
);

-- Clients Table
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Address VARCHAR(255),
    Industry VARCHAR(100),
    ClientSince DATE,
    LocationID INT,
    ApplyDiscount BOOL,
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID) CONSTRAINT FK_ClientLocation
    ON DELETE SET NULL
    ON UPDATE CASCADE
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
    PaymentSubtotal DECIMAL(10, 2),
    DiscountValue DECIMAL(10, 2),
	TaxRate DECIMAL(3, 1), 
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID) CONSTRAINT FK_ProjectClient
    ON DELETE RESTRICT
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

-- Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID) CONSTRAINT FK_DepartmentManager
    ON DELETE RESTRICT 
    ON UPDATE CASCADE
);

-- ProjectConsultants Table
CREATE TABLE ProjectConsultants (
    ProjectID INT,
    EmployeeID INT,
    EmployeeRole VARCHAR(100),
    PRIMARY KEY (ProjectID, EmployeeID),  -- Composite Primary Key
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) CONSTRAINT FK_ConsultantProject
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) CONSTRAINT FK_ConsultantEmployee
    ON DELETE RESTRICT
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
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) CONSTRAINT FK_DataProject
    ON DELETE RESTRICT
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
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) CONSTRAINT FK_ReportProject
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Deliverables Table 
CREATE TABLE Services (
    ServicesID INT PRIMARY KEY AUTO_INCREMENT,
    ProjectID INT,
    ServiceType VARCHAR(255),
    ShortDescription TEXT,
    ServiceDate DATE,
    ServiceCost DECIMAL(100, 2),
    ServiceStatus VARCHAR(50),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) CONSTRAINT FK_ServicesProject
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Skills Table
CREATE TABLE Skills (
    SkillID INT PRIMARY KEY AUTO_INCREMENT,
    SkillName VARCHAR(100),
    SkillLevel VARCHAR(100),
    CertificationRequired VARCHAR(10)
);

-- EmployeeSkills Table (Relationship between Employees and Skills)
CREATE TABLE EmployeeSkills (
    EmployeeID INT,
    SkillID INT,
	PRIMARY KEY (EmployeeID, SkillID),  -- Composite Primary Key
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) CONSTRAINT FK_EmployeeSkillEmployee
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID) CONSTRAINT FK_EmployeeSkillSkill
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Logs Table
CREATE TABLE Logs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    Action VARCHAR(255),
    Description TEXT,
    Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Employees(EmployeeID) CONSTRAINT FK_LogEmployee
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);
