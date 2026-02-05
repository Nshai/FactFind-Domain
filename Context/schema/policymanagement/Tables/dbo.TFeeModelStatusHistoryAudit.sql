CREATE TABLE [dbo].[TFeeModelStatusHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelId] [int] NOT NULL,
[Version] [decimal] (5, 2) NULL,
[RefFeeModelStatusId] [int] NOT NULL,
[ActionType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[UpdatedDate] [datetime] NULL,
[UpdatedBy] [int] NULL,
[FeeModelStatusHistoryNote] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeModelStatusHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeModelStatusHistoryAudit] ADD CONSTRAINT [PK_TFeeModelStatusHistoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
