CREATE TABLE [dbo].[TFeeTieringAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FeeTieringId] [int] NOT NULL,
[FeeId] [int] NOT NULL,
[Threshold] [decimal] (18, 2) NULL,
[Percentage] [decimal] (5, 2) NOT NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeTieringAudit] ADD CONSTRAINT [PK_TFeeTieringAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
