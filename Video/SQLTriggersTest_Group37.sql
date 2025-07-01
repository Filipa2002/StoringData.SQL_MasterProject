-- Test Triggers

-- 1st Trigger [ProjectCreateTrigger]
-- Insert a new client
INSERT INTO Clients (CompanyName, ContactName, Email, Phone, Address, IndustryID, ClientSince, LocationID, ApplyDiscount) VALUES
('AI Solutions Inc.', 'Alexa Johnson', 'alexa.johnson@aisolutions.com', '202-555-0123', '123 AI Lane, San Francisco, CA', 1, '2023-09-01', 1, 1);

-- Insert a new project
INSERT INTO Projects (ClientID, ProjectName, Description, StartDate, EndDate, Status, PaymentSubtotal, DiscountValue, TaxRate) VALUES 
(20, 'AI Chatbot Development', 'Developing an AI chatbot for customer support.', '2023-09-15', '2024-01-15', 'In Progress', 20000.00, 1500.00, 10.0);

-- Insert services for the new project
INSERT INTO Services (ProjectID, ServiceType, ShortDescription, ServiceDate, ServiceCost, ServiceStatus) VALUES
(25, 'AI Training', 'Training the AI model for chatbot responses.', '2023-09-20', 5000.00, 'In Progress'),
(25, 'Chatbot Development', 'Developing the chatbot interface and functionality.', '2023-10-01', 8000.00, 'In Progress'),
(25, 'Integration Testing', 'Testing the chatbot integration with customer platforms.', '2023-11-01', 7000.00, 'In Progress');

-- 2nd Trigger [UpdateProjectAndServicesStatusAfterReport]
-- Insert a report for the new project
INSERT INTO Reports (ProjectID, ReportTitle, ReportDate, ReportContent)
VALUES (25, 'AI Chatbot Development Report', '2023-10-15', 'The AI chatbot development project is progressing well. The chatbot is being trained on customer queries and responses.');