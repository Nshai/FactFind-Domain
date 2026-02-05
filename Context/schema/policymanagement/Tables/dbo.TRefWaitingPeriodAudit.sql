CREATE TABLE [dbo].[TRefWaitingPeriodAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefWaitingPeriodId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefWaitingPeriodAudit] ADD CONSTRAINT [PK_TRefWaitingPeriodAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
