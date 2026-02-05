CREATE TABLE [dbo].[TTransactionSubscriptionCache]
(
[TTransactionSubscriptionCacheId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TransactionServiceProviderId] [int] NULL,
[IndigoClientId] [int] NULL,
[RefGroupId] [int] NULL,
)
GO
ALTER TABLE [dbo].[TTransactionSubscriptionCache] ADD  CONSTRAINT [PK_TTransactionSubscriptionCache] PRIMARY KEY CLUSTERED ([TTransactionSubscriptionCacheId]) WITH (SORT_IN_TEMPDB = OFF)
GO
