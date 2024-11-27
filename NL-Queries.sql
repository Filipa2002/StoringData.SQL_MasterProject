--  Queries
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