-- Step 3: Create Triggers

-- Trigger to log whenever a new project is created
DELIMITER //

CREATE TRIGGER ProjectCreateTrigger 
AFTER INSERT ON Projects
FOR EACH ROW
BEGIN

    -- Variable to store the net payment after discount and tax calculation
    DECLARE TotalPayment DECIMAL(10, 2);

    -- Calculate the net payment
    SET TotalPayment = NEW.PaymentSubtotal - NEW.DiscountValue + (NEW.PaymentSubtotal * NEW.TaxRate / 100);

    INSERT INTO Logs (Action, Description)
    VALUES ('Project Created', 
            CONCAT('New project "', NEW.ProjectName, '" (ID: ', NEW.ProjectID, ') ',        
                   'Created for client (ID: ', NEW.ClientID, '). ',
                   'Start Date: ', NEW.StartDate, ', End Date: ', NEW.EndDate, '. ',
                   'Initial Status: "', NEW.Status, '". ',
                   'Net Payment: ', FORMAT(TotalPayment, 2), ' (Tax Rate: ', NEW.TaxRate, '%).'
        )
    );
END;

//

-- Trigger to update the status of the project and all associated services when a report is inserted
CREATE TRIGGER UpdateProjectAndServicesStatusAfterReport
AFTER INSERT ON Reports
FOR EACH ROW
BEGIN
-- Update the project status to 'Completed'
    UPDATE Projects
    SET Status = 'Completed'
    WHERE ProjectID = NEW.ProjectID;

    -- Update the status of all services associated with the project to 'Completed'
    UPDATE Services
    SET ServiceStatus = 'Completed'
    WHERE ProjectID = NEW.ProjectID;
END;

//

-- Reset the delimiter back to ;
DELIMITER ;