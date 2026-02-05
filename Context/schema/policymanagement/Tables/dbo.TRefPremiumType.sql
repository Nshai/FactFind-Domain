CREATE TABLE [dbo].[TRefPremiumType]
(
[RefPremiumTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefPremiumTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefPremiumType_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPremiumType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPremiumType] ADD CONSTRAINT [PK_TRefPremiumType] PRIMARY KEY NONCLUSTERED  ([RefPremiumTypeId]) WITH (FILLFACTOR=80)
GO
