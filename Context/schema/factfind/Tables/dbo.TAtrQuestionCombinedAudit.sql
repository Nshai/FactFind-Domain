CREATE TABLE [dbo].[TAtrQuestionCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrQuestionId] [int] NOT NULL,
[Description] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Investment] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestionCombinedAudit_Investment] DEFAULT ((0)),
[Retirement] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestionCombinedAudit_Retirement] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestionCombinedAudit_Active] DEFAULT ((0)),
[AtrTemplateGuid] [uniqueidentifier] NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrQuestionCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[Guid] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrQuestionCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrQuestionCombinedAudit] ADD CONSTRAINT [PK_TAtrQuestionCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrQuestionCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TAtrQuestionCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
