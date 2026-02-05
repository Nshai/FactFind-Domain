CREATE TABLE [dbo].[TAtrRefProfilePreferenceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TAtrRefProfilePreferenceAudit_ConcurrencyId] DEFAULT ((1)),
[AtrRefProfilePreferenceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrRefProfilePreferenceAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrRefProfilePreferenceAudit] ADD CONSTRAINT [PK_TAtrRefProfilePreferenceAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRefProfilePreferenceAudit_AtrRefProfilePreferenceId_ConcurrencyId] ON [dbo].[TAtrRefProfilePreferenceAudit] ([AtrRefProfilePreferenceId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
