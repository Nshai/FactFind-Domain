CREATE TABLE [dbo].[TFeeStatusTransition]
(
[FeeStatusTransitionId] [int] NOT NULL IDENTITY(1, 1),
[FeeRefStatusIdFrom] [int] NOT NULL,
[FeeRefStatusIdTo] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeStatusTransition_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeStatusTransition] ADD CONSTRAINT [PK_TFeeStatusTransition] PRIMARY KEY CLUSTERED  ([FeeStatusTransitionId])
GO
ALTER TABLE [dbo].[TFeeStatusTransition] ADD CONSTRAINT [FK_TFeeStatusTransition_TRefFeeStatus] FOREIGN KEY ([FeeRefStatusIdFrom]) REFERENCES [dbo].[TRefFeeStatus] ([RefFeeStatusId])
GO
ALTER TABLE [dbo].[TFeeStatusTransition] ADD CONSTRAINT [FK_TFeeStatusTransition_TRefFeeStatus1] FOREIGN KEY ([FeeRefStatusIdTo]) REFERENCES [dbo].[TRefFeeStatus] ([RefFeeStatusId])
GO
