CREATE TABLE [dbo].[TFeeModelStatusHistory]
(
[FeeModelStatusHistoryId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelId] [int] NOT NULL,
[Version] [decimal] (5, 2) NULL,
[RefFeeModelStatusId] [int] NOT NULL,
[ActionType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[UpdatedDate] [datetime] NULL,
[UpdatedBy] [int] NULL,
[FeeModelStatusHistoryNote] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TFeeModelStatusHistory] ADD CONSTRAINT [PK_TFeeModelStatusHistory] PRIMARY KEY CLUSTERED  ([FeeModelStatusHistoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelStatusHistory_FeeModelId] ON [dbo].[TFeeModelStatusHistory] ([FeeModelId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelStatusHistory_TenantId] ON [dbo].[TFeeModelStatusHistory] ([TenantId])
GO
