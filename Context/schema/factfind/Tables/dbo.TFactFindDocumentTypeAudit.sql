CREATE TABLE [dbo].[TFactFindDocumentTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindDocumentTypeAudit_ConcurrencyId] DEFAULT ((1)),
[FactFindDocumentTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFactFindDocumentTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFactFindDocumentTypeAudit] ADD CONSTRAINT [PK_TFactFindDocumentTypeAudit] PRIMARY KEY NONCLUSTERED  ([FactFindDocumentTypeId]) WITH (FILLFACTOR=80)
GO
