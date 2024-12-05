-- Query 3: Get the average rating for each consultant role
SELECT 
    pc.EmployeeRole, 
    ROUND(AVG(r.Rating),2) AS AverageRating
FROM ProjectConsultants pc
JOIN Ratings r ON pc.ProjectID = r.ProjectID
GROUP BY pc.EmployeeRole
ORDER BY AverageRating DESC;