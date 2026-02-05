CREATE TABLE [dbo].[TFeeStatusTransitionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeRefStatusIdFrom] [int] NOT NULL,
[FeeRefStatusIdTo] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeStatusTransitionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeStatusTransitionAudit] ADD CONSTRAINT [PK_TFeeStatusTransitionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
