CREATE TABLE [dbo].[THouseholdGroup](
	[HouseholdGroupId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HouseholdId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL
) 
GO

ALTER TABLE [dbo].[THouseholdGroup]  WITH CHECK ADD  CONSTRAINT [FK_THouseholdGroup_THousehold] FOREIGN KEY([HouseholdId])
REFERENCES [dbo].[THousehold] ([HouseholdId])
GO

ALTER TABLE [dbo].[THouseholdGroup] CHECK CONSTRAINT [FK_THouseholdGroup_THousehold]
GO


