CREATE TABLE [dbo].[TRefRiskQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Question] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NOT NULL,
[IsArchived] [bit] NOT NULL,
[CreatedBy] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefRiskQuestionId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefRiskQuestionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefRiskCommentId] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefRiskQuestionAudit] ADD CONSTRAINT [PK_TRefRiskQuestionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefRiskQuestionAudit_RefRiskQuestionId_ConcurrencyId] ON [dbo].[TRefRiskQuestionAudit] ([RefRiskQuestionId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
