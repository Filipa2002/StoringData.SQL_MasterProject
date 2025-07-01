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