-- Query 5: Get the total number of projects in progress for each department
SELECT 
    d.DepartmentName, 
    COUNT(p.ProjectID) AS TotalProjectsInProgress
FROM Departments d
JOIN Employees e ON d.ManagerID = e.EmployeeID
JOIN ProjectConsultants pc ON e.EmployeeID = pc.EmployeeID
JOIN Projects p ON pc.ProjectID = p.ProjectID
WHERE p.Status = 'In Progress'
GROUP BY d.DepartmentName
ORDER BY TotalProjectsInProgress DESC;