-- View to get all details for Invoices (Service Type, Service Description, Service Date, Service Cost)
CREATE VIEW InvoiceServiceDetails AS
SELECT
    s.ProjectID AS ProjectNumber,
    p.ProjectName AS ProjectName,
    s.ServiceType,
    s.ShortDescription AS ServiceDescription,
    s.ServiceDate,
    s.ServiceCost,
    s.ServiceStatus
FROM Services s, Projects p
WHERE s.ProjectID = p.ProjectID;