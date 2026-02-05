CREATE TABLE [dbo].[TFeeRecurrence]
(
[FeeRecurrenceId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NOT NULL,
[NextExpectationDate] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeRecurrence_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeRecurrence] ADD CONSTRAINT [PK_TFeeRecurrence] PRIMARY KEY NONCLUSTERED ([FeeRecurrenceId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IX_TFeeRecurrence_FeeID ON [dbo].[TFeeRecurrence] ([FeeId])
GO