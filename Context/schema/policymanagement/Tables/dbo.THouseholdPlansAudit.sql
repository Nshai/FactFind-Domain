CREATE TABLE [dbo].[THouseholdPlanAudit](
	AuditId				INT IDENTITY(1,1) NOT NULL,
	HouseholdPlanId	INT NOT NULL,
	PolicyBusinessId	INT NOT NULL,
	HouseholdId			INT NOT NULL,
	HouseholdGroupId	INT NULL,
	StampAction			CHAR(1) NOT NULL,
	StampDateTime		DATETIME NULL,
	StampUser			VARCHAR(255) NULL,
	CONSTRAINT [PK_THouseholdPlanAudit] PRIMARY KEY NONCLUSTERED 
	(
		AuditId ASC
	)
)
GO

ALTER TABLE [dbo].[THouseholdPlanAudit] ADD  CONSTRAINT [DF_THouseholdPlanAudit_StampDateTime]  DEFAULT (GETDATE()) FOR [StampDateTime]
GO

