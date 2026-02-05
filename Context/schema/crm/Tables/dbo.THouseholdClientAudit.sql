CREATE TABLE [dbo].[THouseholdClientAudit](
	AuditId				INT IDENTITY(1,1) NOT NULL,
	HouseholdClientId	INT NOT NULL,
	HouseholdId			INT NOT NULL,
	CrmContactId		INT NOT NULL, 
	StampAction			CHAR(1) NOT NULL,
	StampDateTime		DATETIME NULL,
	StampUser			VARCHAR(255) NULL,
	CONSTRAINT [PK_THouseholdClientAudit] PRIMARY KEY NONCLUSTERED 
	(
		[AuditId] ASC
	)
)
GO

ALTER TABLE [dbo].[THouseholdClientAudit] ADD  CONSTRAINT [DF_THouseholdClientAudit_StampDateTime]  DEFAULT (GETDATE()) FOR [StampDateTime]
GO


