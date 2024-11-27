DELIMITER $$

-- Trigger to log whenever a new project is created
CREATE TRIGGER ProjectCreateTrigger 
AFTER INSERT ON Projects
FOR EACH ROW
BEGIN
    INSERT INTO Logs (Action, Description, UserID)
    VALUES ('Project Created', CONCAT('New project ', NEW.ProjectName, ' created for client ', NEW.ClientID), 1);
END $$

DELIMITER ;

DELIMITER $$

-- Trigger to log when an invoice is paid
CREATE TRIGGER InvoicePaidTrigger
AFTER UPDATE ON Invoices
FOR EACH ROW
BEGIN
    IF OLD.Status = 'Pending' AND NEW.Status = 'Paid' THEN
        INSERT INTO Logs (Action, Description, UserID)
        VALUES ('Invoice Paid', CONCAT('Invoice ID ', NEW.InvoiceID, ' has been paid for contract ', NEW.ContractID), 1);
    END IF;
END $$

DELIMITER ;

DELIMITER $$

-- Trigger to update the status of the project when it is completed
CREATE TRIGGER UpdateProjectStatusAfterReport
AFTER INSERT ON Reports
FOR EACH ROW
BEGIN
    IF NEW.ReportStatus = 'Final' THEN
        UPDATE Projects
        SET Status = 'Completed'
        WHERE ProjectID = NEW.ProjectID;
    END IF;
END $$

DELIMITER ;

DELIMITER $$