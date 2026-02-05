CREATE TABLE [dbo].[TFeeStatus]
(
[FeeStatusId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NOT NULL,
[Status] [varchar] (50)  NOT NULL,
[StatusNotes] [varchar] (250)  NULL,
[StatusDate] [datetime] NOT NULL,
[UpdatedUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeStatus] ADD CONSTRAINT [PK_TFeeStatus] PRIMARY KEY CLUSTERED  ([FeeStatusId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFeeStatus_FeeId] ON [dbo].[TFeeStatus] ([FeeId])
GO
ALTER TABLE [dbo].[TFeeStatus] ADD CONSTRAINT [FK_TFeeStatus_FeeId_FeeId] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId])
GO
create index IX_TFeeStatus_FeeId on TFeeStatus (FeeId) include (FeeStatusId, Status)
go
CREATE NONCLUSTERED INDEX IX_INCL_TFeeStatus_Staus  ON [dbo].[TFeeStatus] ([Status]) INCLUDE ([FeeId],[StatusDate])
go