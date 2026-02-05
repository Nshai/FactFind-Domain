CREATE TABLE [dbo].[TRefFundTransactionType]
(
[RefFundTransactionTypeId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessFundTransactionType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFundTransactionType] ADD CONSTRAINT [PK_TPolicyBusinessFundTransactionType] PRIMARY KEY CLUSTERED  ([RefFundTransactionTypeId]) WITH (FILLFACTOR=80)
GO
