CREATE TABLE [dbo].[TProtectionMiscellaneousAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[HasExistingProvision] [bit] NULL,
[NonDisclosure] [bit] NULL,
[Notes] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ProtectionMiscellaneousId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProtectionMiscellaneousAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IncomeReplacementRate] [smallint] NULL
)
GO
ALTER TABLE [dbo].[TProtectionMiscellaneousAudit] ADD CONSTRAINT [PK_TProtectionMiscellaneousAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProtectionMiscellaneousAudit_ProtectionMiscellaneousId_ConcurrencyId] ON [dbo].[TProtectionMiscellaneousAudit] ([ProtectionMiscellaneousId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
