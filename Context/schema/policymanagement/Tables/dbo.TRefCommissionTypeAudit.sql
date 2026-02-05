CREATE TABLE [dbo].[TRefCommissionTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CommissionTypeName] [varchar] (50) NULL,
[RefLicenseTypeId] [int] NULL,
[OrigoRef] [varchar] (50) NULL,
[InitialCommissionFg] [tinyint] NULL,
[RecurringCommissionFg] [tinyint] NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefCommissionTypeId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefCommissionTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TRefCommissionTypeAudit] ADD CONSTRAINT [PK_TRefCommissionTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefCommissionTypeAudit_RefCommissionTypeId_ConcurrencyId] ON [dbo].[TRefCommissionTypeAudit] ([RefCommissionTypeId], [ConcurrencyId])
GO
