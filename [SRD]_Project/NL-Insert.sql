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
