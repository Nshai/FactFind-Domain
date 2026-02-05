CREATE TABLE [dbo].[TValSchedulePolicyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ValScheduleId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ClientCRMContactId] [int] NOT NULL,
[UserCredentialOption] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PortalCRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValSchedulePolicyAudit_ConcurrencyId] DEFAULT ((1)),
[ValSchedulePolicyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValSchedulePolicyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValSchedulePolicyAudit] ADD CONSTRAINT [PK_TValSchedulePolicyAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TValSchedulePolicyAudit_ValSchedulePolicyId_ConcurrencyId] ON [dbo].[TValSchedulePolicyAudit] ([ValSchedulePolicyId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
