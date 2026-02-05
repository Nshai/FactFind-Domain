CREATE TABLE [dbo].[TAtrCategoryQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AtrCategoryQuestionId] [int] NOT NULL,
[AtrCategoryGuid] [uniqueidentifier] NOT NULL,
[AtrQuestionGuid] [uniqueidentifier] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrCategoryQuestionAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrCategoryQuestionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrCategoryQuestionAudit] ADD CONSTRAINT [PK_TAtrCategoryQuestionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
