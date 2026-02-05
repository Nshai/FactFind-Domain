CREATE TABLE [dbo].[TReviewDefinitionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ReviewDefinitionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TReviewDefinitionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TReviewDefinitionAudit] ADD CONSTRAINT [PK_TReviewDefinitionAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TReviewDefinitionAudit_ReviewDefinitionId_ConcurrencyId] ON [dbo].[TReviewDefinitionAudit] ([ReviewDefinitionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
