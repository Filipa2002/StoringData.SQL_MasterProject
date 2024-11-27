
-- Step 2: Views

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