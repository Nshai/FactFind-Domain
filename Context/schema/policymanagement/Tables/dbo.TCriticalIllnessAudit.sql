CREATE TABLE [dbo].[TCriticalIllnessAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Amount] [money] NULL,
[Term] [int] NULL,
[RefPremiumTypeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCriticalIllnessAudit_ConcurrencyId] DEFAULT ((1)),
[CriticalIllnessId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCriticalIllnessAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCriticalIllnessAudit] ADD CONSTRAINT [PK_TCriticalIllnessAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TCriticalIllnessAudit_CriticalIllnessId_ConcurrencyId] ON [dbo].[TCriticalIllnessAudit] ([CriticalIllnessId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
