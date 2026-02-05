CREATE TABLE [dbo].[TRefContributionsCoveredType]
(
[RefContributionsCoveredTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefContributionsCoveredType] ADD CONSTRAINT [PK_TRefContributionsCoveredType] PRIMARY KEY CLUSTERED  ([RefContributionsCoveredTypeId])
GO
