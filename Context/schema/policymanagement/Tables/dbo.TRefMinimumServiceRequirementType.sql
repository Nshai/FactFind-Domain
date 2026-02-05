CREATE TABLE [dbo].[TRefMinimumServiceRequirementType]
(
[RefMinimumServiceRequirementTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefMinimumServiceRequirementType] ADD CONSTRAINT [PK_TRefMinimumServiceRequirementType] PRIMARY KEY CLUSTERED  ([RefMinimumServiceRequirementTypeId])
GO
