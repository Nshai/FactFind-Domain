CREATE TABLE [dbo].[TAtrQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Investment] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestionAudit_Investment] DEFAULT ((0)),
[Retirement] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestionAudit_Retirement] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_TAtrQuestionAudit_Active] DEFAULT ((0)),
[AtrTemplateGuid] [uniqueidentifier] NULL,
[IndigoClientId] [int] NOT NULL,
[Guid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrQuestionAudit_ConcurrencyId] DEFAULT ((1)),
[AtrQuestionId] [int] NOT NULL,
[AtrQuestionSyncId] [varchar] (50) CONSTRAINT [DF_TAtrQuestionAudit_AtrQuestionSyncId] DEFAULT (NULL),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrQuestionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrQuestionAudit] ADD CONSTRAINT [PK_TAtrQuestionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrQuestionAudit_AtrQuestionId_ConcurrencyId] ON [dbo].[TAtrQuestionAudit] ([AtrQuestionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
