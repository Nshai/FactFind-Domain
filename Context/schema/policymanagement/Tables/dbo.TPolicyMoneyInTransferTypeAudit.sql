CREATE TABLE [dbo].[TPolicyMoneyInTransferTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyMoneyInId] [int] NOT NULL,
[TransferTypeId] [tinyint] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PolicyMoneyInTransferTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyMoneyInTransferTypeAudit] ADD CONSTRAINT [PK_TPolicyMoneyInTransferTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
