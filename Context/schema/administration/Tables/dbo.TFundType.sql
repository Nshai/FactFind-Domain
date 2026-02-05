CREATE TABLE [dbo].[TFundType]
(
[FundTypeId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Abbreviation] [varchar] (5) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFundType] ADD CONSTRAINT [PK_TFundType] PRIMARY KEY CLUSTERED  ([FundTypeId]) WITH (FILLFACTOR=80)
GO
