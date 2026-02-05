CREATE TABLE [dbo].[THouseholdClient](
	HouseholdClientId		INT IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	HouseholdId				INT NOT NULL,
	CrmContactId			INT NOT NULL,
	CONSTRAINT [PK_THouseholdClientId] PRIMARY KEY NONCLUSTERED 
	(
		HouseholdClientId ASC
	)
)
GO

ALTER TABLE [dbo].[THouseholdClient]  WITH CHECK ADD  CONSTRAINT [FK_THouseholdClient_TCRMContact] FOREIGN KEY([CrmContactId])
REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO

ALTER TABLE [dbo].[THouseholdClient] CHECK CONSTRAINT [FK_THouseholdClient_TCRMContact]
GO

ALTER TABLE [dbo].[THouseholdClient]  WITH CHECK ADD  CONSTRAINT [FK_THouseholdClient_THousehold] FOREIGN KEY([HouseholdId])
REFERENCES [dbo].[THousehold] ([HouseholdId])
GO

ALTER TABLE [dbo].[THouseholdClient] CHECK CONSTRAINT [FK_THouseholdClient_THousehold]
GO



