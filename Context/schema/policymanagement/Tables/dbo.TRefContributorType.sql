CREATE TABLE [dbo].[TRefContributorType]
(
[RefContributorTypeId] [int] NOT NULL IDENTITY(1, 1),
[RefContributorTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefContributorType_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefContributorType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefContributorType] ADD CONSTRAINT [PK_TRefContributorType] PRIMARY KEY NONCLUSTERED  ([RefContributorTypeId]) WITH (FILLFACTOR=80)
GO
