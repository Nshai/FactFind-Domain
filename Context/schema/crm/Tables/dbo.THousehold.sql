CREATE TABLE [dbo].[THousehold](
	[HouseholdId]			INT IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TenantId]				INT NOT NULL,
	[Name]					VARCHAR(50) NOT NULL,
	[Description]			VARCHAR(500) NULL,
	[ServicingAdvisorId] INT NULL,
	[PointOfContactId]	INT NULL,
	[IsArchived]			BIT NOT NULL,
	[CreatedAt]				DATETIME NOT NULL,
	[CreatedBy]				INT NOT NULL,
	CONSTRAINT [PK_THouseholdId] PRIMARY KEY NONCLUSTERED 
	(
		[HouseholdId] ASC
	)
) 
GO

ALTER TABLE [dbo].[THousehold] ADD CONSTRAINT [DF_THousehold_CreatedAt] DEFAULT (GETUTCDATE()) FOR [CreatedAt]
GO

ALTER TABLE [dbo].[THousehold] ADD CONSTRAINT [DF_THousehold_IsArchived] DEFAULT (0) FOR [IsArchived]
GO

ALTER TABLE [dbo].[THousehold]  WITH CHECK ADD  CONSTRAINT [FK_THousehold_TCRMContact] FOREIGN KEY([PointOfContactId])
REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO

ALTER TABLE [dbo].[THousehold] CHECK CONSTRAINT [FK_THousehold_TCRMContact]
GO

ALTER TABLE [dbo].[THousehold]  WITH CHECK ADD  CONSTRAINT [FK_THousehold_TCRMContact1] FOREIGN KEY([ServicingAdvisorid])
REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO

ALTER TABLE [dbo].[THousehold] CHECK CONSTRAINT [FK_THousehold_TCRMContact1]
GO


