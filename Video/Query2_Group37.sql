-- Query 2: Get the total revenue generated from each industry
SELECT 
    i.IndustryName, 
    SUM(p.PaymentSubtotal) AS TotalRevenue
FROM Industries i
JOIN Clients c ON i.IndustryID = c.IndustryID
JOIN Projects p ON c.ClientID = p.ClientID
GROUP BY i.IndustryName
ORDER BY TotalRevenue DESC;