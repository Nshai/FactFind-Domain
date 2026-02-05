CREATE TABLE [dbo].[TIndigoClientPreferenceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PreferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Disabled] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientPreferenceAudit_Disabled] DEFAULT ((0)),
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TIndigoClientPreferenceAudit_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientPreferenceAudit_ConcurrencyId] DEFAULT ((1)),
[IndigoClientPreferenceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientPreferenceAudit] ADD CONSTRAINT [PK_TIndigoClientPreferenceAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
