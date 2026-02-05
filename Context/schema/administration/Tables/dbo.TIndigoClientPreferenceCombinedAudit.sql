CREATE TABLE [dbo].[TIndigoClientPreferenceCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TIndigoClientPreferenceCombinedAudit_Guid] DEFAULT (newid()),
[IndigoClientPreferenceId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PreferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Disabled] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientPreferenceCombinedAudit_Disabled] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientPreferenceCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[msrepl_tran_version] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TIndigoClientPreferenceCombinedAudit_msrepl_tran_version] DEFAULT (newid()),
[IndigoClientPreferenceCombinedId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIndigoClientPreferenceCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientPreferenceCombinedAudit] ADD CONSTRAINT [PK_TIndigoClientPreferenceCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIndigoClientPreferenceCombinedAudit_IndigoClientPreferenceCombinedId_ConcurrencyId] ON [dbo].[TIndigoClientPreferenceCombinedAudit] ([IndigoClientPreferenceCombinedId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
