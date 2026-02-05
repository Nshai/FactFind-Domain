CREATE TABLE [dbo].[TLegalEntityPreferenceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GroupId] [int] NOT NULL,
[PreferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PreferenceValue] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLegalEntityPreferenceAudit_ConcurrencyId] DEFAULT ((0)),
[LegalEntityPreferenceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLegalEntityPreferenceAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLegalEntityPreferenceAudit] ADD CONSTRAINT [PK_TLegalEntityPreferenceAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TLegalEntityPreferenceAudit_LegalEntityPreferenceId_ConcurrencyId] ON [dbo].[TLegalEntityPreferenceAudit] ([LegalEntityPreferenceId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
