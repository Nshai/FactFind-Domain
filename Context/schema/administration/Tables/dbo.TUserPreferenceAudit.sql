CREATE TABLE [dbo].[TUserPreferenceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[PreferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PreferenceValue] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserPreferenceAudit_ConcurrencyId] DEFAULT ((0)),
[UserPreferenceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TUserPreferenceAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TUserPreferenceAudit] ADD CONSTRAINT [PK_TUserPreferenceAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TUserPreferenceAudit_UserPreferenceId_ConcurrencyId] ON [dbo].[TUserPreferenceAudit] ([UserPreferenceId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
