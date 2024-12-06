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