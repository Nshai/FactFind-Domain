CREATE TABLE [dbo].[TActivityOutcomeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ActivityOutcomeName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TActivityOutcomeAudit_ArchiveFG] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityOutcomeAudit_ConcurrencyId] DEFAULT ((1)),
[ActivityOutcomeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityOutcomeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GroupId] [int] NULL
)
GO
ALTER TABLE [dbo].[TActivityOutcomeAudit] ADD CONSTRAINT [PK_TActivityOutcomeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
