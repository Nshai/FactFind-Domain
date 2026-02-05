CREATE TABLE [dbo].[TFeeRecurrenceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NOT NULL,
[NextExpectationDate] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeRecurrenceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL,
[StampUser] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TFeeRecurrenceAudit] ADD CONSTRAINT [PK_TFeeRecurrenceAudit] PRIMARY KEY NONCLUSTERED ([AuditId]) WITH (FILLFACTOR=80)
GO
Create NonClustered index X_TFeeRecurrenceAudit_FeeRecurrenceId on dbo.tfeerecurrenceaudit (FeeRecurrenceId)