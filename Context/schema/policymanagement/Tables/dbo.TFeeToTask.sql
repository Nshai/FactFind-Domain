CREATE TABLE [dbo].[TFeeToTask]
(
[FeeToTaskId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NOT NULL,
[TaskId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFeeToTask_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeToTask] ADD CONSTRAINT [PK_TFeeToTask] PRIMARY KEY CLUSTERED  ([FeeToTaskId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeToTask_TenantId] ON [dbo].[TFeeToTask] ([TenantId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeToTask_TaskId] ON [dbo].[TFeeToTask] ([TaskId])
GO
ALTER TABLE [dbo].[TFeeToTask] ADD CONSTRAINT [FK_TFeeToTask_TFee] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId]) ON DELETE CASCADE
GO
create index IX_TFeeToTask_FeeID on TfeeToTask (feeid) 
go
