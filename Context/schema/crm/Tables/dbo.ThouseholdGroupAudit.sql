CREATE TABLE [dbo].[THouseholdGroupAudit](
	AuditId				INT IDENTITY(1,1) NOT NULL,
	HouseholdGroupId	INT NOT NULL,
	HouseholdId			INT NOT NULL,
	[Name]				VARCHAR(50) NOT NULL,
	StampAction			CHAR(1) NOT NULL,
	StampDateTime		DATETIME NULL,
	StampUser			VARCHAR(255) NULL,
	CONSTRAINT [PK_THouseholdGroupAudit] PRIMARY KEY NONCLUSTERED 
	(
		AuditId ASC
	)
) 
GO

ALTER TABLE [dbo].[THouseholdGroupAudit] ADD  CONSTRAINT [DF_THouseholdGroupAudit_StampDateTime]  DEFAULT (GETDATE()) FOR [StampDateTime]
GO



