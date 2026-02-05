CREATE TABLE [dbo].[TRefContributionType]
(
[RefContributionTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefContributionTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefContributionType_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefContributionType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefContributionType] ADD CONSTRAINT [PK_TRefContributionType] PRIMARY KEY NONCLUSTERED  ([RefContributionTypeId]) WITH (FILLFACTOR=80)
GO
