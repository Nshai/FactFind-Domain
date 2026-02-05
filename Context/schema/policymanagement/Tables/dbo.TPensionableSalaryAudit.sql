CREATE TABLE [dbo].[TPensionableSalaryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TenantId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[PensionableSalary] [money] NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[IsCurrent] [bit] NULL,
[ActionDate] [datetime] NULL,
[HasBeenActioned] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPensionableSalaryAudit_ConcurrencyId] DEFAULT ((1)),
[PensionableSalaryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPensionableSalaryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPensionableSalaryAudit] ADD CONSTRAINT [PK_TPensionableSalaryAudit] PRIMARY KEY NONCLUSTERED ([AuditId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPensionableSalaryAudit_PensionableSalaryId_ConcurrencyId] ON [dbo].[TPensionableSalaryAudit] ([PensionableSalaryId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IX_TPensionableSalaryAudit_StampDateTime_ProtectionId] ON [dbo].[TPensionableSalaryAudit] ([StampDateTime], [PensionableSalaryId]) WITH (FILLFACTOR=90)
GO
