CREATE TABLE [dbo].[TAtrTemplateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Descriptor] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[Active] [bit] NOT NULL,
[HasModels] [bit] NOT NULL,
[BaseAtrTemplate] [uniqueidentifier] NULL,
[AtrRefPortfolioTypeId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplateAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL,
[AtrTemplateId] [int] NOT NULL,
[AtrTemplateSyncId] [int] CONSTRAINT [DF_TAtrTemplateAudit_AtrTemplateSyncId] DEFAULT (NULL),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrTemplateAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[HasFreeTextAnswers] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplateAudit_HasFreeTextAnswers] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TAtrTemplateAudit] ADD CONSTRAINT [PK_TAtrTemplateAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrTemplateAudit_AtrTemplateId_ConcurrencyId] ON [dbo].[TAtrTemplateAudit] ([AtrTemplateId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
