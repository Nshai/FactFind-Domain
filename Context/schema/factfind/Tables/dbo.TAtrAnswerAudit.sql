CREATE TABLE [dbo].[TAtrAnswerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Weighting] [int] NOT NULL,
[AtrQuestionGuid] [uniqueidentifier] NULL,
[IndigoClientId] [int] NOT NULL,
[Guid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TAtrAnswerAudit_ConcurrencyId] DEFAULT ((1)),
[AtrAnswerId] [int] NOT NULL,
[AtrAnswerSyncId][varchar] (50) CONSTRAINT [DF_TAtrAnswerAudit_AtrAnswerSyncId] DEFAULT (NULL),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrAnswerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrAnswerAudit] ADD CONSTRAINT [PK_TAtrAnswerAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrAnswerAudit_AtrAnswerId_ConcurrencyId] ON [dbo].[TAtrAnswerAudit] ([AtrAnswerId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
