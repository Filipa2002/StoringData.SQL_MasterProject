-- Step 5: Create Views

-- View to get all information of head and totals for Invoices(Invoice Number, Project Number, Project Date , Client Information, Subtotal, 
-- 															   Tax, Discount, Total Paid, Total Due)
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