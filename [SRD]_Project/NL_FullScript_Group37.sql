-- Step 1: Create Database

DROP DATABASE IF EXISTS NOVAloitteDB;
CREATE DATABASE IF NOT EXISTS NOVAloitteDB;
USE NOVAloitteDB;

-- Locations Table 
CREATE TABLE Locations (
    LocationID TINYINT PRIMARY KEY AUTO_INCREMENT,         -- Use TINYINT for small range of values (Optimized for performance)
    City VARCHAR(100),                                     -- City name can be up to 100 characters
    Country VARCHAR(100)                                   -- Country name can be up to 100 characters
);

-- Industries Table
CREATE TABLE Industries (
    IndustryID TINYINT PRIMARY KEY AUTO_INCREMENT,         -- Use TINYINT for small range of values (Optimized for performance)
    IndustryName VARCHAR(100)                              -- Industry name can be up to 100 characters
);

-- Clients Table
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY AUTO_INCREMENT,                -- Use INT for larger range of values (We may have many clients)
    CompanyName VARCHAR(255),                               -- Company name can be up to 255 characters
    ContactName VARCHAR(255),                               -- Contact person name can be up to 255 characters
    Email VARCHAR(255),                                     -- Email can be up to 255 characters
    Phone VARCHAR(20),                                      -- Phone number can be up to 20 characters
    Address VARCHAR(255),                                   -- Address can be up to 255 characters
    IndustryID TINYINT NOT NULL,                            -- IndustryID as Foreign Key (Mandatory)   
    ClientSince DATE,                                       -- Date when client started working with us
    LocationID TINYINT NOT NULL,                            -- LocationID as Foreign Key (Mandatory)
    ApplyDiscount BOOLEAN DEFAULT 0,                        -- Apply discount by default is false (0)
    -- Foreign Key Constraints 
    CONSTRAINT FK_ClientIndustry FOREIGN KEY (IndustryID)   -- Define Foreign Key Constraint for IndustryID
        REFERENCES Industries(IndustryID) 
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_ClientLocation FOREIGN KEY (LocationID)   -- Define Foreign Key Constraint for LocationID
        REFERENCES Locations(LocationID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Projects Table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY AUTO_INCREMENT,               -- Use INT for larger range of values (We may have many projects)
    ClientID INT NOT NULL,                                  -- ClientID as Foreign Key (Mandatory)
    ProjectName VARCHAR(255),                               -- Project name can be up to 255 characters
    Description TEXT,                                       -- Description can be long text
    StartDate DATE,                                         -- Start date of the project
    EndDate DATE,                                           -- End date of the project
    Status VARCHAR(11) CHECK (Status IN ('Completed', 'In Progress')), -- Status can be 'Completed' or 'In Progress'
    PaymentSubtotal DECIMAL(10, 2),                         -- Payment subtotal for the project with 2 decimal places and up to 10 digits
    DiscountValue DECIMAL(10, 2) DEFAULT 0,                 -- Discount value can be 0 if no discount applied
	TaxRate DECIMAL(3, 1),                                  -- Tax rate in percentage [0.0 - 99.9]
    CONSTRAINT FK_ProjectClient FOREIGN KEY (ClientID)      -- Define Foreign Key Constraint for ClientID
        REFERENCES Clients(ClientID) 
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CHECK (StartDate <= EndDate),                             -- Ensure StartDate is before or equal to EndDate
    CHECK (PaymentSubtotal >= 0),                            -- Ensure PaymentSubtotal is non-negative
    CHECK (DiscountValue >= 0),                              -- Ensure DiscountValue is non-negative
    CHECK (PaymentSubtotal >= DiscountValue),                -- Ensure PaymentSubtotal is greater than or equal to DiscountValue
    CHECK (TaxRate >= 0 AND TaxRate <= 100)                 -- Ensure TaxRate is between 0 and 100
);

-- Ratings Table
CREATE TABLE Ratings (
    ProjectID INT NOT NULL,                                  -- ProjectID as Foreign Key (Mandatory)
    ClientID INT NOT NULL,                                   -- ClientID as Foreign Key (Mandatory)
    Rating DECIMAL(2, 1)                                     -- Rating with 1 decimal places and up to 2 digits (e.g., 4.5)
        CHECK (Rating >= 0 AND Rating <= 5),                 -- Restrict the rating to be between 0 and 5
    Review TEXT DEFAULT NULL,                                -- Review is optional and by default is NULL
    PRIMARY KEY (ProjectID, ClientID),                       -- Composite Primary Key (ProjectID, ClientID)
    CONSTRAINT FK_RatingProject FOREIGN KEY (ProjectID)      -- Define Foreign Key Constraint for ProjectID
        REFERENCES Projects(ProjectID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_RatingClient FOREIGN KEY (ClientID)        -- Define Foreign Key Constraint for ClientID
        REFERENCES Clients(ClientID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Departments Table
CREATE TABLE Departments (
    DepartmentID TINYINT PRIMARY KEY AUTO_INCREMENT,          -- Use TINYINT for small range of values (Optimized for performance)
    DepartmentName VARCHAR(100),                              -- Department name can be up to 100 characters
    ManagerID INT NOT NULL                                    -- ManagerID as Foreign Key (Mandatory)
);

-- Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,                -- Use INT for larger range of values (We may have many employees)
    FirstName VARCHAR(100),                                   -- First name can be up to 100 characters
    LastName VARCHAR(100),                                    -- Last name can be up to 100 characters
    Position VARCHAR(100),                                    -- Position can be up to 100 characters
    HireDate DATE,                                            -- Hire date of the employee
    Email VARCHAR(255),                                       -- Email can be up to 255 characters
    Phone VARCHAR(20),                                        -- Phone number can be up to 20 characters
    Salary DECIMAL(10, 2),                                    -- Salary with 2 decimal places and up to 10 digits
    DepartmentID TINYINT NOT NULL,                            -- DepartmentID as Foreign Key
    CONSTRAINT FK_EmployeeDepartment FOREIGN KEY (DepartmentID) -- Define Foreign Key Constraint for DepartmentID
        REFERENCES Departments(DepartmentID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CHECK (Salary >= 0)                                       -- Ensure Salary is non-negative
);

-- ProjectConsultants Table
CREATE TABLE ProjectConsultants (
    ProjectID INT NOT NULL,                                   -- ProjectID as Foreign Key (Mandatory)
    EmployeeID INT NOT NULL,                                  -- EmployeeID as Foreign Key (Mandatory)
    EmployeeRole VARCHAR(100),                                -- Role of the employee in the project
    PRIMARY KEY (ProjectID, EmployeeID),                      -- Composite Primary Key
    CONSTRAINT FK_ConsultantProject FOREIGN KEY (ProjectID)   -- Define Foreign Key Constraint for ProjectID
        REFERENCES Projects(ProjectID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_ConsultantEmployee FOREIGN KEY (EmployeeID)  -- Define Foreign Key Constraint for EmployeeID
        REFERENCES Employees(EmployeeID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- CollectedData Table
CREATE TABLE CollectedData (
    DataID INT PRIMARY KEY AUTO_INCREMENT,                     -- Use INT for larger range of values (We may have many data entries)
    ProjectID INT NOT NULL,                                    -- ProjectID as Foreign Key (Mandatory)
    DataType VARCHAR(100),                                     -- Type of data collected (e.g., Survey, Metrics, Report)
    Format VARCHAR(50),                                        -- Format of the data (e.g., CSV, JSON, XML)
    CollectionDate DATE,                                       -- Date when data was collected
    CONSTRAINT FK_DataProject FOREIGN KEY (ProjectID)          -- Define Foreign Key Constraint for ProjectID
        REFERENCES Projects(ProjectID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Reports Table
CREATE TABLE Reports (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,                    -- Use INT for larger range of values (We may have many reports)
    ProjectID INT NOT NULL,                                     -- ProjectID as Foreign Key
    ReportTitle VARCHAR(255),                                   -- Title of the report
    ReportDate DATE,                                            -- Date when the report was created
    ReportContent TEXT,                                         -- Content of the report
    CONSTRAINT FK_ReportProject FOREIGN KEY (ProjectID)         -- Define Foreign Key Constraint for ProjectID
        REFERENCES Projects(ProjectID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Services Table 
CREATE TABLE Services (
    ServicesID INT PRIMARY KEY AUTO_INCREMENT,                  -- Use INT for larger range of values (We may have many services)
    ProjectID INT NOT NULL,                                     -- ProjectID as Foreign Key (Mandatory)
    ServiceType VARCHAR(100),                                   -- Type of service provided (e.g., Consulting, Development, Training)
    ShortDescription VARCHAR(500),                              -- Short description of the service provided (up to 500 characters)
    ServiceDate DATE,                                           -- Date when the service was provided
    ServiceCost DECIMAL(10, 2),                                 -- Cost of the service
    ServiceStatus VARCHAR(11) 
        CHECK (ServiceStatus IN ('Completed', 'In Progress')),         -- Status of the service can be 'Completed' or 'In Progress'
    CONSTRAINT FK_ServicesProject FOREIGN KEY (ProjectID)       -- Define Foreign Key Constraint for ProjectID
        REFERENCES Projects(ProjectID)    
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CHECK (ServiceCost >= 0)                                    -- Ensure ServiceCost is non-negative
);

-- Skills Table
CREATE TABLE Skills (
    SkillID TINYINT PRIMARY KEY AUTO_INCREMENT,                  -- Use TINYINT for small range of values (Optimized for performance)
    SkillName VARCHAR(100),                                      -- Skill name can be up to 100 characters
    SkillLevel VARCHAR(100),                                     -- Skill level (e.g., Beginner, Intermediate, Advanced, Expert)
    CertificationRequired BOOLEAN DEFAULT 0                      -- Certification required for the skill (Yes - 1, No - 0)
);

-- EmployeeSkills Table
CREATE TABLE EmployeeSkills (
    EmployeeID INT NOT NULL,                                      -- EmployeeID as Foreign Key (Mandatory)
    SkillID TINYINT NOT NULL,                                     -- SkillID as Foreign Key (Mandatory)
	PRIMARY KEY (EmployeeID, SkillID),                            -- Composite Primary Key (EmployeeID, SkillID)
    CONSTRAINT FK_EmployeeSkillEmployee FOREIGN KEY (EmployeeID)  -- Define Foreign Key Constraint for EmployeeID
        REFERENCES Employees(EmployeeID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_EmployeeSkillSkill FOREIGN KEY (SkillID)         -- Define Foreign Key Constraint for SkillID
        REFERENCES Skills(SkillID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Logs Table
CREATE TABLE Logs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,                          -- Use INT for larger range of values (We may have many logs)
    Action VARCHAR(50),                                            -- Action performed (e.g., Project Created)
    Description TEXT,                                              -- Description of the action
    Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP                       -- Date and time of the action (Auto-generated)
);


-- ############################################################################################################

-- Step 2: Insert Data

-- Insert Locations
INSERT INTO Locations (City, Country) VALUES
('New York', 'USA'),
('London', 'UK'),
('Tokyo', 'Japan'),
('Berlin', 'Germany'),
('Paris', 'France'),
('Sydney', 'Australia'),
('Mumbai', 'India'),
('São Paulo', 'Brazil'),
('Cape Town', 'South Africa'),
('Buenos Aires', 'Argentina'),
('Dubai', 'UAE'),
('Singapore', 'Singapore'),
('Los Angeles', 'USA'),
('Toronto', 'Canada'),
('Mexico City', 'Mexico'),
('Vienna', 'Austria'),
('Madrid', 'Spain'),
('Seoul', 'South Korea'),
('Chicago', 'USA');

-- Insert Industry
INSERT INTO Industries (IndustryName) VALUES
('Technology'),
('Consulting'),
('Creative'),
('Cloud Services'),
('Tech Consulting');

-- Insert Clients
INSERT INTO Clients (CompanyName, ContactName, Email, Phone, Address, IndustryID, ClientSince, LocationID, ApplyDiscount) VALUES
('Tech Innovations Ltd.', 'Alice Green', 'alice.green@techinn.com', '202-555-0123', '123 Tech Lane, New York, NY', 1, '2018-01-15', 1, 1),
('NextGen Solutions', 'Robert Hill', 'robert.hill@nextgen.com', '202-555-0456', '456 Nextgen Ave, London, UK', 2, '2019-06-20', 2, 0),
('Quantum Systems', 'Eleanor Adams', 'eleanor.adams@quantum.com', '202-555-0789', '789 Quantum Blvd, Tokyo, Japan', 1, '2020-11-30', 3, 1),
('Digital Creators', 'Johan Werner', 'johan.werner@digitalcreators.de', '202-555-0345', '101 Digital Rd, Berlin, Germany', 3, '2021-04-15', 4, 1),
('Futuristic Insights', 'Marie Dupont', 'marie.dupont@futuristics.com', '202-555-0678', '123 Vision St, Paris, France', 2, '2017-02-25', 5, 0),
('Cloud Pioneers', 'David Lee', 'david.lee@cloudpioneers.com', '202-555-0912', '456 Cloud Way, Toronto, Canada', 4, '2022-07-10', 6, 1),
('Innovation & Beyond', 'Ming Wong', 'ming.wong@innovation.com', '202-555-0347', '789 Creative Blvd, Sydney, Australia', 2, '2018-11-14', 7, 0),
('Data Dynamics', 'Anjali Patel', 'anjali.patel@datadynamics.in', '202-555-0976', '987 Data St, Mumbai, India', 1, '2020-03-05', 8, 1),
('Visionary Projects', 'Carlos Ruiz', 'carlos.ruiz@visionaryprojects.com', '202-555-0012', '321 Vision Ave, São Paulo, Brazil', 2, '2022-08-19', 9, 1),
('South Africa Ventures', 'Cynthia Booysen', 'cynthia.b@sfventures.com', '202-555-0198', '234 Tech Tower, Cape Town, South Africa', 2, '2017-10-23', 10, 0),
('InnovateX', 'Esteban Martinez', 'esteban.martinez@innovatex.com', '202-555-0654', '567 Innovate Blvd, Buenos Aires, Argentina', 1, '2023-03-15', 11, 1),
('Futureworks Consulting', 'James O’Connor', 'james.oconnor@futureworks.com', '202-555-0834', '987 Strategy Ln, Dubai, UAE', 2, '2020-01-07', 12, 0),
('Smart Solutions', 'Rina Tan', 'rina.tan@smartech.com', '202-555-0746', '222 Solutions Rd, Singapore', 5, '2022-05-28', 13, 1),
('TechScope', 'Victor Nguyen', 'victor.nguyen@techscope.com', '202-555-0321', '654 Tech Blvd, Los Angeles, USA', 1, '2019-11-11', 14, 1),
('SmartTech Innovations', 'Felipe Silva', 'felipe.silva@smarttech.com', '202-555-0905', '123 Tech Plaza, Mexico City, Mexico', 1, '2022-02-13', 15, 0),
('NextEra Solutions', 'Thomas Weber', 'thomas.weber@nextsolutions.com', '202-555-0548', '345 NextEra St, Vienna, Austria', 1, '2021-07-23', 16, 1),
('Sky Innovations', 'Kyung Min', 'kyung.min@skyinnovations.kr', '202-555-0192', '876 Sky Way, Seoul, South Korea', 1, '2019-05-19', 17, 1),
('TechWorks', 'Jessica Chang', 'jessica.chang@techworks.com', '202-555-0778', '234 Development Rd, Chicago, USA', 2, '2022-11-02', 18, 0),
('CloudVision', 'Lucas Fernando', 'lucas.fernando@cloudvision.com', '202-555-0143', '101 Cloud Blvd, New York, NY', 5, '2020-08-29', 19, 1);

-- Insert Projects
INSERT INTO Projects (ClientID, ProjectName, Description, StartDate, EndDate, Status, PaymentSubtotal, DiscountValue, TaxRate) VALUES
(1, 'Cloud Migration', 'Cloud migration project for Tech Innovations.', '2023-01-15', '2023-05-15', 'Completed', 20000.00, 1000.00, 10.0),
(1, 'Tech Infrastructure Upgrade', 'Upgrading tech infrastructure for Tech Innovations.', '2023-05-01', '2024-10-01', 'In Progress', 15000.00, 0.00, 10.0),
(2, 'Market Expansion Analysis', 'Analysis of market trends for NextGen Solutions.', '2023-03-01', '2023-07-01', 'In Progress', 25000.00, 0.00, 10.0),
(2, 'Strategic Partnership Development', 'Developing strategic partnerships for NextGen Solutions.', '2023-07-01', '2024-12-01', 'In Progress', 22000.00, 0.00, 10.0),
(3, 'Data Analytics Integration', 'Integrating advanced data analytics for Quantum Systems.', '2023-06-20', '2024-12-20', 'In Progress', 35000.00, 1500.00, 8.0),
(3, 'Cloud Optimization', 'Optimizing cloud infrastructure for Quantum Systems.', '2023-09-01', '2024-12-01', 'In Progress', 26500.00, 0.00, 8.0),
(4, 'UX/UI Overhaul', 'Complete redesign of the user experience for Digital Creators.', '2023-02-10', '2023-06-10', 'Completed', 21000.00, 900.00, 10.0),
(5, 'AI Implementation', 'Developing AI solutions for Futuristic Insights.', '2023-07-20', '2024-12-31', 'In Progress', 27000.00, 0.00, 9.0),
(6, 'Cloud Security Enhancement', 'Improving cloud security for Cloud Pioneers.', '2023-08-05', '2023-11-05', 'Completed', 20000.00, 1100.00, 10.0),
(6, 'Cloud Backup Solutions', 'Providing cloud backup solutions for Cloud Pioneers.', '2023-10-01', '2025-03-01', 'In Progress', 20000.00, 0.00, 10.0),
(7, 'Big Data Solutions', 'Providing big data analytics for Innovation & Beyond.', '2023-04-17', '2024-10-17', 'In Progress', 30000.00, 0.00, 8.0),
(8, 'Automation Strategy', 'Designing automation strategies for Data Dynamics.', '2023-05-01', '2023-09-01', 'Completed', 26000.00, 1300.00, 10.0),
(9, 'Cybersecurity Assessment', 'Conducting a cybersecurity audit for Visionary Projects.', '2023-06-10', '2023-09-30', 'Completed', 21000.00, 950.00, 9.0),
(9, 'Digital Security Solutions', 'Providing digital security solutions for Visionary Projects.', '2023-10-01', '2025-03-01', 'In Progress', 25000.00, 0.00, 9.0),
(10, 'Blockchain Integration', 'Integrating blockchain technology for South Africa Ventures.', '2023-03-15', '2024-07-15', 'In Progress', 32000.00, 0.00, 8.0),
(11, 'Data Processing Overhaul', 'Improving data processing systems for InnovateX.', '2023-01-23', '2023-06-23', 'Completed', 23000.00, 1000.00, 9.0),
(12, 'Digital Transformation', 'Helping Futureworks Consulting with their digital transformation.', '2023-08-15', '2024-12-15', 'In Progress', 35000.00, 0.00, 10.0),
(13, 'Data Center Development', 'Building new data center for Smart Solutions.', '2023-09-10', '2025-03-10', 'In Progress', 40000.00, 1800.00, 8.0),
(14, 'Cloud App Development', 'Developing cloud-based applications for TechScope.', '2023-02-12', '2023-06-12', 'Completed', 19000.00, 800.00, 9.0),
(15, 'Blockchain Solutions', 'Blockchain development for Innovative Enterprises.', '2023-07-30', '2024-11-30', 'Completed', 27000.00, 0.00, 9.0),
(16, 'IT Infrastructure Setup', 'Setting up IT infrastructure for NextEra Solutions.', '2023-08-01', '2023-12-01', 'Completed', 24000.00, 1200.00, 8.0),
(17, 'Data Migration', 'Migrating legacy systems to new platforms for Sky Innovations.', '2023-04-15', '2023-08-15', 'Completed', 22000.00, 1100.00, 10.0),
(18, 'Tech Support Services', 'Providing tech support for TechWorks clients.', '2023-07-01', '2024-12-31', 'In Progress', 21000.00, 0.00, 9.0),
(19, 'Cloud Consulting', 'Consulting for CloudVision regarding cloud infrastructure.', '2023-06-01', '2024-09-01', 'In Progress', 25000.00, 1200.00, 10.0);

-- Insert Ratings
INSERT INTO Ratings (ProjectID, ClientID, Rating, Review) VALUES
(1, 1, 4.5, 'Great work on the cloud migration.'),
(2, 1, 4.0, 'Tech infrastructure upgrade is progressing well.'),
(3, 2, 2.8, 'Good analysis but could be more detailed.'),
(4, 2, 3.5, 'Strategic partnership development is on track.'),
(5, 3, 4.2, NULL),
(6, 3, 3.9, 'Cloud optimization is improving performance.'),
(7, 4, 4.8, 'UX/UI overhaul has enhanced user experience.'),
(8, 5, 3.7, 'AI implementation is showing promising results.'),
(9, 5, 4.3, 'Cloud security enhancement is top-notch.'),
(10, 6, 4.6, 'Cloud backup solutions are reliable.'),
(11, 7, 4.1, 'Big data solutions are providing valuable insights.'),
(12, 8, 4.7, 'Automation strategies have increased efficiency.'),
(13, 9, 4.4, 'Cybersecurity assessment was thorough.'),
(14, 9, 4.0, 'Digital security solutions are robust.'),
(15, 10, 4.9, 'Blockchain integration is secure and efficient.'),
(16, 11, 4.3, 'Data processing overhaul has improved speed.'),
(17, 12, 4.8, 'Digital transformation is transforming our business.'),
(18, 13, 4.5, 'Data center development is progressing well.'),
(19, 14, 4.2, 'Cloud app development has been successful.'),
(20, 15, 4.6, 'Blockchain solutions are innovative.'),
(21, 16, 2.7, NULL),
(22, 17, 4.4, 'Data migration was seamless.'),
(23, 18, 4.0, 'Tech support services are responsive.'),
(24, 19, 4.5, 'Cloud consulting has been valuable.');

-- Insert Departments
INSERT INTO Departments (DepartmentName, ManagerID) VALUES
('Tech', 1),
('Sales', 2),
('Development', 3),
('HR', 4),
('Marketing', 6),
('Finance', 9);

-- Insert Employees with more diverse and creative names
INSERT INTO Employees (FirstName, LastName, Position, HireDate, Email, Phone, Salary, DepartmentID) VALUES
('Aiden', 'Kumar', 'Cloud Solutions Architect', '2020-01-15', 'aiden.kumar@novaloitte.com', '987-654-3210', 102000.00, 1),
('Lena', 'Nguyen', 'Data Scientist', '2021-07-03', 'lena.nguyen@novaloitte.com', '654-321-9870', 92000.00, 2),
('Santiago', 'Ruiz', 'Full Stack Developer', '2022-06-30', 'santiago.ruiz@novaloitte.com', '321-987-6540', 84000.00, 3),
('Yara', 'Al-Farsi', 'Business Intelligence Analyst', '2019-10-25', 'yara.alfarsi@novaloitte.com', '876-543-2109', 77000.00, 4),
('Ravi', 'Patel', 'AI Researcher', '2021-02-19', 'ravi.patel@novaloitte.com', '543-210-9876', 98000.00, 4), 
('Kirsten', 'Olsen', 'Product Manager', '2020-05-11', 'kirsten.olsen@novaloitte.com', '765-432-1098', 93000.00, 5),
('Marcelo', 'Duarte', 'Cybersecurity Engineer', '2019-03-07', 'marcelo.duarte@novaloitte.com', '432-109-8765', 105000.00, 1),
('Priya', 'Iyer', 'Data Analyst', '2022-01-14', 'priya.iyer@novaloitte.com', '210-987-6543', 77000.00, 1),
('Khalid', 'Bin Zayed', 'Cloud Infrastructure Manager', '2021-04-23', 'khalid.zayed@novaloitte.com', '543-678-9012', 102500.00, 6),
('Haruto', 'Yamamoto', 'DevOps Engineer', '2020-09-01', 'haruto.yamamoto@novaloitte.com', '890-123-4567', 88000.00, 1),
('Camila', 'Rodrigues', 'UX/UI Designer', '2022-05-19', 'camila.rodrigues@novaloitte.com', '789-012-3456', 76000.00, 2),
('Oluwaseun', 'Adebayo', 'Blockchain Developer', '2021-11-30', 'oluwaseun.adebayo@novaloitte.com', '678-901-2345', 115000.00, 1),
('Esmeralda', 'Hernández', 'Project Manager', '2019-07-20', 'esmeralda.hernandez@novaloitte.com', '321-456-9870', 95000.00, 5),
('Zara', 'Khan', 'Software Engineer', '2022-09-08', 'zara.khan@novaloitte.com', '987-654-3210', 85000.00, 1),
('Victor', 'Petrov', 'IT Support Specialist', '2020-04-15', 'victor.petrov@novaloitte.com', '654-321-0987', 71000.00, 1),
('Ananya', 'Gupta', 'Network Architect', '2021-08-05', 'ananya.gupta@novaloitte.com', '321-987-6540', 97000.00, 3),
('Mikko', 'Lehtinen', 'Front-End Developer', '2021-12-01', 'mikko.lehtinen@novaloitte.com', '876-543-2109', 78000.00, 3),
('Carmen', 'Gonzalez', 'Business Development Manager', '2020-06-20', 'carmen.gonzalez@novaloitte.com', '210-987-6543', 88000.00, 2),
('Liang', 'Wei', 'Machine Learning Engineer', '2022-10-15', 'liang.wei@novaloitte.com', '654-321-9870', 101000.00, 3),
('Dina', 'El-Sayed', 'Digital Transformation Consultant', '2019-12-01', 'dina.elsayed@novaloitte.com', '543-678-9012', 95000.00, 5),
('Nia', 'Mwangi', 'Mobile App Developer', '2021-07-18', 'nia.mwangi@novaloitte.com', '987-654-3210', 76000.00, 3);

-- Define Foreign Key Constraint for ManagerID
ALTER TABLE Departments ADD CONSTRAINT FK_DepartmentManager FOREIGN KEY (ManagerID)
    REFERENCES Employees(EmployeeID) 
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- Insert Skills
INSERT INTO Skills (SkillName, SkillLevel, CertificationRequired) VALUES
('Project Management', 'Advanced', 1),
('Cloud Computing', 'Intermediate', 0),
('Data Analysis', 'Expert', 1),
('Machine Learning', 'Intermediate', 1),
('Blockchain Development', 'Expert', 1),
('Cybersecurity', 'Advanced', 1),
('UX/UI Design', 'Intermediate', 0),
('Artificial Intelligence', 'Expert', 1),
('Software Development', 'Advanced', 1),
('Database Administration', 'Intermediate', 0),
('Business Strategy', 'Expert', 0),
('Digital Marketing', 'Intermediate', 0),
('Mobile App Development', 'Advanced', 1),
('Cloud Security', 'Expert', 1),
('Web Development', 'Intermediate', 0),
('Business Intelligence', 'Advanced', 1),
('Network Administration', 'Intermediate', 0),
('Data Engineering', 'Expert', 1),
('Big Data Analysis', 'Intermediate', 0),
('DevOps', 'Expert', 1);

-- Insert EmployeeSkills
INSERT INTO EmployeeSkills (EmployeeID, SkillID) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(5, 8),
(5, 9),
(6, 10),
(6, 11),
(7, 12),
(7, 13),
(8, 14),
(8, 15),
(9, 16),
(9, 17),
(10, 18),
(10, 19),
(11, 20),
(12, 1),
(12, 3),
(13, 4),
(13, 5),
(14, 6),
(14, 7),
(15, 8),
(15, 9),
(16, 10),
(16, 11),
(17, 12),
(18, 13),
(19, 14),
(19, 15),
(20, 16);

-- Insert ProjectConsultants
INSERT INTO ProjectConsultants (ProjectID, EmployeeID, EmployeeRole) VALUES
(1, 1, 'Project Manager'),
(1, 3, 'Cloud Architect'),
(2, 4, 'Data Analyst'),
(2, 5, 'Market Strategist'),
(3, 6, 'AI Developer'),
(3, 7, 'Security Specialist'),
(4, 8, 'UX Designer'),
(4, 9, 'UI Developer'),
(5, 10, 'Blockchain Consultant'),
(5, 11, 'Machine Learning Expert'),
(6, 12, 'Cloud Security Expert'),
(6, 13, 'DevOps Engineer'),
(7, 14, 'Big Data Engineer'),
(7, 15, 'Business Analyst'),
(8, 16, 'Software Engineer'),
(8, 17, 'Tech Support Lead'),
(9, 18, 'Cybersecurity Expert'),
(9, 19, 'Network Administrator'),
(10, 20, 'Blockchain Developer'),
(10, 1, 'Consultant'),
(11, 2, 'Project Coordinator'),
(12, 3, 'Senior Consultant'),
(13, 4, 'Lead Engineer'),
(14, 5, 'App Developer'),
(15, 6, 'Business Consultant'),
(16, 7, 'Technical Advisor'),
(17, 8, 'Solutions Architect'),
(18, 9, 'IT Support Specialist'),
(19, 10, 'Cloud Consultant'),
(20, 11, 'Service Manager'),
(20, 12, 'Product Specialist'),
(21, 13, 'Data Scientist'),
(21, 14, 'AI Researcher'),
(22, 15, 'Blockchain Developer'),
(22, 16, 'Security Analyst'),
(23, 17, 'UX/UI Designer'),
(23, 18, 'Front-End Developer'),
(24, 19, 'Business Intelligence Analyst'),
(24, 20, 'Data Engineer');

-- Insert CollectedData
INSERT INTO CollectedData (ProjectID, DataType, Format, CollectionDate) VALUES
(1, 'Survey', 'CSV', '2023-01-25'),
(1, 'Cloud Metrics', 'JSON', '2023-02-15'),
(2, 'Market Trends', 'PDF', '2023-04-05'),
(2, 'Competitive Analysis', 'CSV', '2023-05-01'),
(3, 'Analytics Report', 'XML', '2023-07-10'),
(3, 'Customer Data', 'JSON', '2023-08-20'),
(4, 'User Feedback', 'CSV', '2023-03-01'),
(4, 'Design Prototypes', 'PNG', '2023-04-15'),
(5, 'AI Training Data', 'CSV', '2023-05-01'),
(5, 'Algorithm Results', 'JSON', '2023-06-10'),
(6, 'Security Logs', 'TXT', '2023-08-30'),
(6, 'Cloud Monitoring', 'CSV', '2023-09-05'),
(7, 'Big Data Insights', 'CSV', '2023-06-12'),
(7, 'Customer Feedback', 'JSON', '2023-07-01'),
(8, 'Automation Logs', 'CSV', '2023-05-10'),
(8, 'Performance Reports', 'PDF', '2023-06-05'),
(9, 'Security Assessment Data', 'TXT', '2023-06-15'),
(9, 'Audit Logs', 'XML', '2023-07-10'),
(10, 'Blockchain Metrics', 'CSV', '2023-08-20'),
(10, 'Transaction Data', 'JSON', '2023-09-01');

-- Insert Reports [Project already 'Completed']
INSERT INTO Reports (ProjectID, ReportTitle, ReportDate, ReportContent) VALUES
(1, 'Cloud Migration Report', '2023-05-20', 'The cloud migration project was successfully completed with minimal downtime and data loss. The new cloud infrastructure is now fully operational and secure.'),
(4, 'UX/UI Overhaul Report', '2023-06-15', 'The UX/UI redesign project resulted in a significant improvement in user experience and engagement. The new design elements have been well-received by users.'),
(7, 'Big Data Solutions Report', '2023-10-20', 'The big data analytics project has provided valuable insights into customer behavior and market trends. The data-driven approach has helped optimize business strategies.'),
(8, 'Automation Strategy Report', '2023-09-10', 'The automation strategies implemented have streamlined business processes and increased operational efficiency. The automated workflows have reduced manual errors and improved productivity.'),
(11, 'Data Processing Overhaul Report', '2023-06-30', 'The data processing overhaul project has significantly improved data processing speed and accuracy. The new system can handle large datasets more efficiently.'),
(14, 'Cloud App Development Report', '2023-06-20', 'The cloud-based application development project has delivered a user-friendly and scalable application for internal use. The app has improved workflow efficiency and data accessibility.'),
(17, 'IT Infrastructure Setup Report', '2023-12-05', 'The IT infrastructure setup project has successfully established a robust and secure infrastructure for business operations. The new setup has enhanced network performance and data security.'),
(18, 'Data Migration Report', '2023-08-20', 'The data migration project has migrated legacy systems to new platforms seamlessly. The migration process was completed without data loss or disruptions to business operations.');

-- Insert Services
INSERT INTO Services (ProjectID, ServiceType, ShortDescription, ServiceDate, ServiceCost, ServiceStatus) VALUES
-- Project 1
(1, 'Cloud Hosting', 'Provisioning of cloud hosting services for the client.', '2023-01-30', 6000.00, 'Completed'),
(1, 'Data Migration', 'Migrating data to the cloud infrastructure.', '2023-02-15', 7000.00, 'Completed'),
(1, 'Security Setup', 'Implementing security measures for the cloud infrastructure.', '2023-03-01', 7000.00, 'Completed'),
-- Project 2
(2, 'Market Research', 'Providing detailed market research on industry trends.', '2023-04-10', 5000.00, 'Completed'),
(2, 'Infrastructure Analysis', 'Analyzing the current tech infrastructure.', '2023-05-01', 5000.00, 'In Progress'),
(2, 'Upgrade Implementation', 'Implementing the infrastructure upgrade.', '2023-06-01', 5000.00, 'In Progress'),
-- Project 3
(3, 'Data Analytics', 'Delivering analytical insights to improve data-driven decision-making.', '2024-07-12', 12500.00, 'In Progress'),
(3, 'Market Trends Analysis', 'Analyzing market trends for strategic decisions.', '2023-04-01', 6250.00, 'In Progress'),
(3, 'Reporting', 'Providing detailed reports on market expansion.', '2023-05-01', 6250.00, 'In Progress'),
-- Project 4
(4, 'UX/UI Design', 'Redesign of the client’s website UI for improved user experience.', '2023-04-01', 8000.00, 'Completed'),
(4, 'Implementation', 'Implementing the new UI design.', '2023-05-01', 14000.00, 'Completed'),
-- Project 5
(5, 'AI Implementation', 'Integrating AI-driven solutions into the client’s business processes.', '2024-05-05', 15000.00, 'In Progress'),
(5, 'Data Analysis', 'Analyzing data for AI integration.', '2023-08-01', 10000.00, 'In Progress'),
(5, 'Model Training', 'Training AI models for the client’s needs.', '2023-10-01', 10000.00, 'In Progress'),
-- Project 6
(6, 'Cloud Security Setup', 'Implementing security measures for the cloud infrastructure.', '2023-08-01', 20000.00, 'In Progress'),
(6, 'Security Audit', 'Conducting a security audit of the cloud infrastructure.', '2023-09-01', 3500.00, 'In Progress'),
(6, 'Monitoring', 'Setting up monitoring for the cloud infrastructure.', '2023-10-01', 3000.00, 'In Progress'),
-- Project 7
(7, 'Big Data Integration', 'Integration of big data solutions to handle large datasets efficiently.', '2023-06-05', 10000.00, 'Completed'),
(7, 'Data Analysis', 'Analyzing big data for insights.', '2023-07-01', 8000.00, 'Completed'),
(7, 'Reporting', 'Providing detailed reports on big data analytics.', '2023-08-01', 3000.00, 'Completed'),
-- Project 8
(8, 'Automation Tools', 'Delivering automation tools for increased operational efficiency.', '2023-05-25', 9000.00, 'Completed'),
(8, 'Implementation', 'Implementing automation tools.', '2023-06-01', 9000.00, 'Completed'),
(8, 'Training', 'Training staff on the use of automation tools.', '2023-06-15', 9000.00, 'Completed'),
-- Project 9
(9, 'Cybersecurity Audit', 'Performing cybersecurity audits to detect vulnerabilities in systems.', '2023-06-10', 7000.00, 'Completed'),
(9, 'Security Implementation', 'Implementing security measures based on audit findings.', '2023-07-01', 7000.00, 'Completed'),
(9, 'Monitoring', 'Setting up monitoring for cybersecurity.', '2023-08-01', 6000.00, 'Completed'),
-- Project 10
(10, 'Blockchain Implementation', 'Deploying blockchain solutions for enhanced transparency.', '2024-07-20', 10000.00, 'Completed'),
(10, 'Smart Contracts', 'Developing smart contracts for the client.', '2023-08-01', 5000.00, 'Completed'),
(10, 'Integration', 'Integrating blockchain with existing systems.', '2023-09-01', 5000.00, 'Completed'),
-- Project 11
(11, 'Data Processing System', 'Overhauling the data processing system to improve speed and efficiency.', '2023-04-01', 10000.00, 'Completed'),
(11, 'Data Analysis', 'Analyzing data for processing improvements.', '2023-05-01', 5000.00, 'Completed'),
(11, 'Implementation', 'Implementing the new data processing system.', '2023-06-01', 15000.00, 'Completed'),
-- Project 12
(12, 'Digital Transformation', 'Providing digital transformation services for business process optimization.', '2024-08-15', 20000.00, 'In Progress'),
(12, 'Process Analysis', 'Analyzing business processes for digital transformation.', '2023-09-01', 6000.00, 'In Progress'),
-- Project 13
(13, 'Data Center Setup', 'Establishing a new data center to increase operational capacity.', '2024-09-01', 20000.00, 'In Progress'),
(13, 'Implementation', 'Implementing the data center setup.', '2023-11-01', 1000.00, 'In Progress'),
-- Project 14
(14, 'Cloud App Development', 'Developing a cloud-based application for the client’s internal use.', '2023-03-15', 20000.00, 'Completed'),
(14, 'Testing', 'Testing the cloud-based application.', '2023-04-01', 2500.00, 'Completed'),
(14, 'Deployment', 'Deploying the cloud-based application.', '2023-04-15', 2500.00, 'Completed'),
-- Project 15
(15, 'Blockchain Development', 'Blockchain application development for secure transactions.', '2024-06-01', 11000.00, 'In Progress'),
(15, 'Smart Contracts', 'Developing smart contracts for the client.', '2023-07-01', 9000.00, 'In Progress'),
(15, 'Integration', 'Integrating blockchain with existing systems.', '2023-08-01', 12000.00, 'In Progress'),
-- Project 16
(16, 'Mobile App Optimization', 'Enhancing the client’s mobile app to increase performance.', '2023-07-01', 8000.00, 'In Progress'),
(16, 'Testing', 'Testing the mobile app for performance.', '2023-08-01', 8000.00, 'In Progress'),
(16, 'Deployment', 'Deploying the optimized mobile app.', '2023-09-01', 7000.00, 'In Progress'),
-- Project 17
(17, 'IT Infrastructure Setup', 'Setting up the IT infrastructure for smooth business operations.', '2023-08-25', 35000.00, 'Completed'),
-- Project 18
(18, 'Data Migration', 'Migrating the client’s data to the latest technology platform.', '2023-06-05', 20000.00, 'Completed'),
(18, 'Testing', 'Testing the migrated data.', '2023-07-01', 10000.00, 'Completed'),
(18, 'Deployment', 'Deploying the migrated data.', '2023-07-15', 10000.00, 'Completed'),
-- Project 19
(19, 'Tech Support', 'Providing ongoing tech support services for client operations.', '2024-09-01', 9000.00, 'In Progress'),
(19, 'Issue Resolution', 'Resolving technical issues for the client.', '2023-10-01', 5000.00, 'In Progress'),
(19, 'Training', 'Training staff on tech support procedures.', '2023-11-01', 5000.00, 'In Progress'),
-- Project 20
(20, 'Cloud Consulting', 'Providing consulting services for cloud infrastructure optimization.', '2024-08-01', 27000.00, 'In Progress'),
-- Project 21
(21, 'Data Analysis', 'Analyzing data for insights.', '2023-07-01', 8000.00, 'In Progress'),
(21, 'Reporting', 'Providing detailed reports on data analysis.', '2023-08-01', 3000.00, 'In Progress'),
(21, 'Data Visualization', 'Creating visualizations for data analysis.', '2023-09-01', 13000.00, 'In Progress'),
-- Project 22
(22, 'Security Audit', 'Conducting a security audit of the client’s systems.', '2023-06-10', 8000.00, 'Completed'),
(22, 'Security Implementation', 'Implementing security measures based on audit findings.', '2023-07-01', 8000.00, 'Completed'),
(22, 'Monitoring', 'Setting up monitoring for cybersecurity.', '2023-08-01', 6000.00, 'Completed'),
-- Project 23
(23, 'Blockchain Implementation', 'Deploying blockchain solutions for enhanced transparency.', '2024-07-20', 10000.00, 'Completed'),
(23, 'Smart Contracts', 'Developing smart contracts for the client.', '2023-08-01', 5000.00, 'Completed'),
(23, 'Integration', 'Integrating blockchain with existing systems.', '2023-09-01', 6000.00, 'Completed'),
-- Project 24
(24, 'Tech Support', 'Providing ongoing tech support services for client operations.', '2024-09-01', 20000.00, 'In Progress'),
(24, 'Issue Resolution', 'Resolving technical issues for the client.', '2023-10-01', 2500.00, 'In Progress'),
(24, 'Training', 'Training staff on tech support procedures.', '2023-11-01', 2500.00, 'In Progress');

-- Insert Logs
INSERT INTO Logs (Action, Description, Date) VALUES
('Project Created', 'New project "Cloud Migration" (ID: 1) created for client (ID: 1). Start Date: 2023-01-15, End Date: 2023-05-15. Initial Status: "Completed". Net Payment: 19800.00 (Tax Rate: 10%).', '2023-01-15 12:00:00'),
('Project Created', 'New project "Tech Infrastructure Upgrade" (ID: 2) created for client (ID: 1). Start Date: 2023-05-01, End Date: 2024-10-01. Initial Status: "In Progress". Net Payment: 13500.00 (Tax Rate: 10%).', '2023-05-01 12:00:00'),
('Project Created', 'New project "Market Expansion Analysis" (ID: 3) created for client (ID: 2). Start Date: 2023-03-01, End Date: 2023-07-01. Initial Status: "In Progress". Net Payment: 22500.00 (Tax Rate: 10%).', '2023-03-01 12:00:00'),
('Project Created', 'New project "Strategic Partnership Development" (ID: 4) created for client (ID: 2). Start Date: 2023-07-01, End Date: 2024-12-01. Initial Status: "In Progress". Net Payment: 19800.00 (Tax Rate: 10%).', '2023-07-01 12:00:00'),
('Project Created', 'New project "Data Analytics Integration" (ID: 5) created for client (ID: 3). Start Date: 2023-06-20, End Date: 2024-12-20. Initial Status: "In Progress". Net Payment: 33900.00 (Tax Rate: 8%).', '2023-06-20 12:00:00'),
('Project Created', 'New project "Cloud Optimization" (ID: 6) created for client (ID: 3). Start Date: 2023-09-01, End Date: 2024-12-01. Initial Status: "In Progress". Net Payment: 24840.00 (Tax Rate: 8%).', '2023-09-01 12:00:00'),
('Project Created', 'New project "UX/UI Overhaul" (ID: 7) created for client (ID: 4). Start Date: 2023-02-10, End Date: 2023-06-10. Initial Status: "Completed". Net Payment: 17100.00 (Tax Rate: 10%).', '2023-02-10 12:00:00'),
('Project Created', 'New project "AI Implementation" (ID: 8) created for client (ID: 5). Start Date: 2023-07-20, End Date: 2024-12-31. Initial Status: "In Progress". Net Payment: 24660.00 (Tax Rate: 9%).', '2023-07-20 12:00:00'),
('Project Created', 'New project "Cloud Security Enhancement" (ID: 9) created for client (ID: 6). Start Date: 2023-08-05, End Date: 2023-11-05. Initial Status: "Completed". Net Payment: 19800.00 (Tax Rate: 10%).', '2023-08-05 12:00:00'),
('Project Created', 'New project "Cloud Backup Solutions" (ID: 10) created for client (ID: 6). Start Date: 2023-10-01, End Date: 2025-03-01. Initial Status: "In Progress". Net Payment: 18000.00 (Tax Rate: 10%).', '2023-10-01 12:00:00'),
('Project Created', 'New project "Big Data Solutions" (ID: 11) created for client (ID: 7). Start Date: 2023-04-17, End Date: 2024-10-17. Initial Status: "In Progress". Net Payment: 27000.00 (Tax Rate: 8%).', '2023-04-17 12:00:00'),
('Project Created', 'New project "Automation Strategy" (ID: 12) created for client (ID: 8). Start Date: 2023-05-01, End Date: 2023-09-01. Initial Status: "Completed". Net Payment: 23400.00 (Tax Rate: 10%).', '2023-05-01 12:00:00'),
('Project Created', 'New project "Cybersecurity Assessment" (ID: 13) created for client (ID: 9). Start Date: 2023-06-10, End Date: 2023-09-30. Initial Status: "Completed". Net Payment: 20150.00 (Tax Rate: 9%).', '2023-06-10 12:00:00'),
('Project Created', 'New project "Digital Security Solutions" (ID: 14) created for client (ID: 9). Start Date: 2023-10-01, End Date: 2025-03-01. Initial Status: "In Progress". Net Payment: 23100.00 (Tax Rate: 9%).', '2023-10-01 12:00:00'),
('Project Created', 'New project "Blockchain Integration" (ID: 15) created for client (ID: 10). Start Date: 2023-03-15, End Date: 2024-07-15. Initial Status: "In Progress". Net Payment: 28800.00 (Tax Rate: 8%).', '2023-03-15 12:00:00'),
('Project Created', 'New project "Data Processing Overhaul" (ID: 16) created for client (ID: 11). Start Date: 2023-01-23, End Date: 2023-06-23. Initial Status: "Completed". Net Payment: 20700.00 (Tax Rate: 9%).', '2023-01-23 12:00:00'),
('Project Created', 'New project "Digital Transformation" (ID: 17) created for client (ID: 12). Start Date: 2023-08-15, End Date: 2024-12-15. Initial Status: "In Progress". Net Payment: 31500.00 (Tax Rate: 10%).', '2023-08-15 12:00:00'),
('Project Created', 'New project "Data Center Development" (ID: 18) created for client (ID: 13). Start Date: 2023-09-10, End Date: 2025-03-10. Initial Status: "In Progress". Net Payment: 38280.00 (Tax Rate: 8%).', '2023-09-10 12:00:00'),
('Project Created', 'New project "Cloud App Development" (ID: 19) created for client (ID: 14). Start Date: 2023-02-12, End Date: 2023-06-12. Initial Status: "Completed". Net Payment: 17100.00 (Tax Rate: 9%).', '2023-02-12 12:00:00'),
('Project Created', 'New project "Blockchain Solutions" (ID: 20) created for client (ID: 15). Start Date: 2023-07-30, End Date: 2024-11-30. Initial Status: "Completed". Net Payment: 24660.00 (Tax Rate: 9%).', '2023-07-30 12:00:00'),
('Project Created', 'New project "IT Infrastructure Setup" (ID: 21) created for client (ID: 16). Start Date: 2023-08-01, End Date: 2023-12-01. Initial Status: "Completed". Net Payment: 21600.00 (Tax Rate: 8%).', '2023-08-01 12:00:00'),
('Project Created', 'New project "Data Migration" (ID: 22) created for client (ID: 17). Start Date: 2023-04-15, End Date: 2023-08-15. Initial Status: "Completed". Net Payment: 19800.00 (Tax Rate: 10%).', '2023-04-15 12:00:00'),
('Project Created', 'New project "Tech Support Services" (ID: 23) created for client (ID: 18). Start Date: 2023-07-01, End Date: 2024-12-31. Initial Status: "In Progress". Net Payment: 18900.00 (Tax Rate: 9%).', '2023-07-01 12:00:00'),
('Project Created', 'New project "Cloud Consulting" (ID: 24) created for client (ID: 19). Start Date: 2023-06-01, End Date: 2024-09-01. Initial Status: "In Progress". Net Payment: 26400.00 (Tax Rate: 10%).', '2023-06-01 12:00:00');

-- ############################################################################################################

-- Step 3: Create Triggers

-- Trigger to log whenever a new project is created
DELIMITER //

CREATE TRIGGER ProjectCreateTrigger 
AFTER INSERT ON Projects
FOR EACH ROW
BEGIN

    -- Variable to store the net payment after discount and tax calculation
    DECLARE TotalPayment DECIMAL(10, 2);

    -- Calculate the net payment
    SET TotalPayment = NEW.PaymentSubtotal - NEW.DiscountValue + (NEW.PaymentSubtotal * NEW.TaxRate / 100);

    INSERT INTO Logs (Action, Description)
    VALUES ('Project Created', 
            CONCAT('New project "', NEW.ProjectName, '" (ID: ', NEW.ProjectID, ') ',        
                   'Created for client (ID: ', NEW.ClientID, '). ',
                   'Start Date: ', NEW.StartDate, ', End Date: ', NEW.EndDate, '. ',
                   'Initial Status: "', NEW.Status, '". ',
                   'Net Payment: ', FORMAT(TotalPayment, 2), ' (Tax Rate: ', NEW.TaxRate, '%).'
        )
    );
END;

//

-- Trigger to update the status of the project and all associated services when a report is inserted
CREATE TRIGGER UpdateProjectAndServicesStatusAfterReport
AFTER INSERT ON Reports
FOR EACH ROW
BEGIN
-- Update the project status to 'Completed'
    UPDATE Projects
    SET Status = 'Completed'
    WHERE ProjectID = NEW.ProjectID;

    -- Update the status of all services associated with the project to 'Completed'
    UPDATE Services
    SET ServiceStatus = 'Completed'
    WHERE ProjectID = NEW.ProjectID;
END;

//

-- Reset the delimiter back to ;
DELIMITER ;

-- ============================================================================================================

-- Test Triggers
-- Insert a new client
INSERT INTO Clients (CompanyName, ContactName, Email, Phone, Address, IndustryID, ClientSince, LocationID, ApplyDiscount) VALUES
('AI Solutions Inc.', 'Alexa Johnson', 'alexa.johnson@aisolutions.com', '202-555-0123', '123 AI Lane, San Francisco, CA', 1, '2023-09-01', 1, 1);

-- Insert a new project
INSERT INTO Projects (ClientID, ProjectName, Description, StartDate, EndDate, Status, PaymentSubtotal, DiscountValue, TaxRate) VALUES 
(20, 'AI Chatbot Development', 'Developing an AI chatbot for customer support.', '2023-09-15', '2024-01-15', 'In Progress', 20000.00, 1500.00, 10.0);

-- Insert services for the new project
INSERT INTO Services (ProjectID, ServiceType, ShortDescription, ServiceDate, ServiceCost, ServiceStatus) VALUES
(25, 'AI Training', 'Training the AI model for chatbot responses.', '2023-09-20', 5000.00, 'In Progress'),
(25, 'Chatbot Development', 'Developing the chatbot interface and functionality.', '2023-10-01', 8000.00, 'In Progress'),
(25, 'Integration Testing', 'Testing the chatbot integration with customer platforms.', '2023-11-01', 7000.00, 'In Progress');

-- Insert a report for the new project
INSERT INTO Reports (ProjectID, ReportTitle, ReportDate, ReportContent)
VALUES (25, 'AI Chatbot Development Report', '2023-10-15', 'The AI chatbot development project is progressing well. The chatbot is being trained on customer queries and responses.');


-- ############################################################################################################

-- Step 4: Queries
--         Make a list of 5 business questions that the CEO of the fictitious company may be interested to 
--         know and then, write or generate/tune queries for those 5 business questions. 
--         NOTE: From the 5queries, at least 3 of them must use joins and grouping.

-- Query 1: Get the total number of projects for each client
SELECT 
    c.CompanyName, 
    COUNT(p.ProjectID) AS TotalProjects
FROM Clients c
JOIN Projects p ON c.ClientID = p.ClientID
GROUP BY c.CompanyName
ORDER BY TotalProjects DESC;

-- Query 2: Get the total revenue generated from each industry
SELECT 
    i.IndustryName, 
    SUM(p.PaymentSubtotal) AS TotalRevenue
FROM Industries i
JOIN Clients c ON i.IndustryID = c.IndustryID
JOIN Projects p ON c.ClientID = p.ClientID
GROUP BY i.IndustryName
ORDER BY TotalRevenue DESC;

-- Query 3: Get the average rating for each consultant role
SELECT 
    pc.EmployeeRole, 
    ROUND(AVG(r.Rating),1) AS AverageRating
FROM ProjectConsultants pc
JOIN Ratings r ON pc.ProjectID = r.ProjectID
GROUP BY pc.EmployeeRole
ORDER BY AverageRating DESC;

-- Query 4: Get the total invoiced in 2024
SELECT
    ROUND(SUM(p.PaymentSubtotal + (p.PaymentSubtotal * p.TaxRate / 100) - p.DiscountValue), 2) AS TotalInvoiced2024
FROM Projects p
WHERE YEAR(p.EndDate) = 2024;

-- Query 5: Get the total number of projects 'In Progress' for each department
SELECT 
    d.DepartmentName, 
    COUNT(DISTINCT p.ProjectID) AS TotalProjectsInProgress
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
JOIN ProjectConsultants pc ON e.EmployeeID = pc.EmployeeID
JOIN Projects p ON pc.ProjectID = p.ProjectID
WHERE p.Status = 'In Progress'
GROUP BY d.DepartmentName
ORDER BY TotalProjectsInProgress DESC;

-- ############################################################################################################

-- Step 5: Create Views

-- View to get all information of head and totals for Invoices(Invoice Number, Project Number, Project Date , Client Information, Subtotal, Tax, Discount, Total Paid, Total Due)
CREATE VIEW InvoiceHeadTotals AS
SELECT
    p.ProjectID AS InvoiceNumber,
    p.ProjectID AS ProjectNumber,
    p.ProjectName AS ProjectName,
    p.EndDate AS ProjectDate,
    c.CompanyName AS ClientCompany,
    c.ContactName AS ClientContact,
    c.Email AS ClientEmail,
    c.Phone AS ClientPhone,
    c.Address AS ClientAddress,
    p.PaymentSubtotal AS Subtotal,
    p.TaxRate AS TaxRate,
    (p.PaymentSubtotal * p.TaxRate / 100) AS ValueAddedTax,
    p.DiscountValue AS Discount,
    (p.PaymentSubtotal + (p.PaymentSubtotal * p.TaxRate / 100) - p.DiscountValue) AS TotalToPay
FROM Projects p
JOIN Clients c ON p.ClientID = c.ClientID;

-- View to get all details for Invoices (Service Type, Service Description, Quantity, Service Date, Service Cost)
CREATE VIEW InvoiceServiceDetails AS
SELECT
    s.ProjectID AS ProjectNumber,
    p.ProjectName AS ProjectName,
    s.ServiceType, 
    s.ShortDescription AS ServiceDescription,
    s.ServiceDate,
    s.ServiceCost,
    s.ServiceStatus,
    COUNT(s.ShortDescription) AS Quantity     -- Assuming each service is unique for a project
FROM Services s, Projects p
WHERE s.ProjectID = p.ProjectID
GROUP BY     
    s.ProjectID,
    p.ProjectName,
    s.ServiceType,
    s.ShortDescription,
    s.ServiceDate,
    s.ServiceCost,
    s.ServiceStatus;


-- ############################################################################################################