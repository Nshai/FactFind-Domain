CREATE TABLE [dbo].[TAtrTemplateCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AtrTemplateId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Descriptor] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[Active] [bit] NOT NULL,
[HasModels] [bit] NOT NULL,
[BaseAtrTemplate] [uniqueidentifier] NULL,
[AtrRefPortfolioTypeId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplateCombinedAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrTemplateCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[HasFreeTextAnswers] [bit] NOT NULL CONSTRAINT [DF_TAtrTemplateCombinedAudit_HasFreeTextAnswers] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TAtrTemplateCombinedAudit] ADD CONSTRAINT [PK_TAtrTemplateCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrTemplateCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TAtrTemplateCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
