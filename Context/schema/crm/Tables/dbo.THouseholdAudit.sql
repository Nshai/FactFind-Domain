CREATE TABLE [dbo].[THouseholdAudit](
	[AuditId]				INT IDENTITY(1,1) NOT NULL,
	[HouseholdId]			INT,
	[TenantId]				INT NOT NULL,
	[Name]					VARCHAR(50) NOT NULL,
	[Description]			VARCHAR(500) NULL,
	[ServicingAdvisorId] INT NULL,
	[PointOfContactId]	INT NULL,
	[IsArchived]			BIT NOT NULL,
	[CreatedAt]				DATETIME NOT NULL,
	[CreatedBy]				INT NOT NULL,
	[StampAction]			CHAR(1) NOT NULL,
	[StampDateTime]		DATETIME NULL,
	[StampUser]				VARCHAR(255) NULL,
	CONSTRAINT [PK_THouseholdAudit] PRIMARY KEY NONCLUSTERED 
	(
		[AuditId] ASC
	)
) 
GO

ALTER TABLE [dbo].[THouseholdAudit] ADD  CONSTRAINT [DF_THouseholdAudit_StampDateTime]  DEFAULT (GETDATE()) FOR [StampDateTime]
GO


