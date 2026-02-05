SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[FnGetInforceAndPipelineStatus]()
RETURNS @status table 
(
	StatusName nvarchar(100)
) 
AS
BEGIN
	Insert Into @status values
	('Valuation Instructed'),
	('Pending'),
	('New Business Checking'),
	('Submitted to Provider'),
	('Ready For Submission'),
	('Client Sign up'),
	('Pre-Approved'),
	('Submit to CO'),
	('Compliance File Passed and Cleared'),
	('Awaiting CSO'),
	('AQU Sign Off'),
	('Pre-Approval'),
	('Submitted To T and C'),
	('Pre-Approval (New Business Checking)'),
	('Underwriting'),
	('In force'),
	('Application Received'),
	('Paid Up'),
	('Account Opened'),
	('Accepted'),
	('Sent To Service Delivery'),
	('Ready For Commission'),
	('G60 sign off'),
	('Draft'),
	('Invoiced'),
	('Submitted to CO'),
	('a/w CSO'),
	('Pre Approval Check'),
	('Offer Made'),
	('Fund Switch'),
	('Compliance Sign off')
	RETURN 
END
GO
