CREATE TABLE [dbo].[TRefExpenditureType2ExpenditureGroup]
(
	[RefExpenditureType2ExpenditureGroupId][int] NOT NULL IDENTITY(1, 1),
	[ExpenditureTypeId] [int] NOT NULL 
						CONSTRAINT [FK_TRefExpenditureType2ExpenditureGroup_ExpenditureTypeId_ExpenditureTypeId] 
						FOREIGN KEY REFERENCES [dbo].[TRefExpenditureType] ([RefExpenditureTypeId]),
	[ExpenditureGroupId] [int] NOT NULL 
						CONSTRAINT [FK_TRefExpenditureType2ExpenditureGroup_ExpenditureGroupId_ExpenditureGroupId] 
						FOREIGN KEY REFERENCES [dbo].[TRefExpenditureGroup] ([RefExpenditureGroupId])
)