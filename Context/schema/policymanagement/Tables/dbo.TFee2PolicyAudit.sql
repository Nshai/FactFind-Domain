CREATE TABLE [dbo].[TFee2PolicyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NULL,
[PolicyBusinessId] [int] NULL,
[RebateCommission] [bit] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL,
[Fee2PolicyId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFee2PolicyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TFee2PolicyAudit] ADD CONSTRAINT [PK_TFee2PolicyAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TFee2PolicyAudit_Fee2PolicyId_ConcurrencyId] ON [dbo].[TFee2PolicyAudit] ([Fee2PolicyId], [ConcurrencyId])
GO
