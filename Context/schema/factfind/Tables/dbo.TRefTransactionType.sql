CREATE TABLE [dbo].[TRefTransactionType]
(
[RefTransactionTypeId] [int] NOT NULL IDENTITY(1, 1),
[TransactionType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTransactionType_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefTransactionType] ADD CONSTRAINT [PK_TRefTransactionType] PRIMARY KEY NONCLUSTERED  ([RefTransactionTypeId])
GO
