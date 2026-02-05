CREATE TABLE [dbo].[TTransactionReportDeclaration]
(
[TransactionReportDeclarationId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[Declaration] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTransactionReportDeclaration] ADD CONSTRAINT [PK_TTransactionReportDeclaration] PRIMARY KEY CLUSTERED  ([TransactionReportDeclarationId])
GO
