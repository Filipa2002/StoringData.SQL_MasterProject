-- Query 4: Get the total invoiced in 2024
SELECT
    ROUND(SUM(p.PaymentSubtotal + (p.PaymentSubtotal * p.TaxRate / 100) - p.DiscountValue), 2) AS TotalInvoiced2024
FROM Projects p
WHERE YEAR(p.EndDate) = 2024;