CREATE TABLE [dbo].[TTransactionImportLog]
(
[TransactionImportLogId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[BatchId] [uniqueidentifier] NULL,
AttemptedAt Datetime2 NULL,
FinishedAt Datetime2 NULL,
ImportResult VARCHAR(MAX) NULL,
ErrorMessage VARCHAR(MAX) NULL
)
GO
ALTER TABLE [dbo].[TTransactionImportLog] ADD  CONSTRAINT [PK_TransactionImportLog] PRIMARY KEY CLUSTERED ([TransactionImportLogId]) WITH (SORT_IN_TEMPDB = OFF)
GO
