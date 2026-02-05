CREATE TABLE [dbo].[TAtrAnswerCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrAnswerId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Weighting] [int] NOT NULL,
[AtrQuestionGuid] [uniqueidentifier] NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAnswerCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[Guid] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrAnswerCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrAnswerCombinedAudit] ADD CONSTRAINT [PK_TAtrAnswerCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrAnswerCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TAtrAnswerCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
