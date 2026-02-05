CREATE TABLE [dbo].[TAtrMatrixTermAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Starting] [tinyint] NULL,
[Ending] [tinyint] NULL,
[IndigoClientId] [int] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrMatrixTermAudit_ConcurrencyId] DEFAULT ((1)),
[AtrMatrixTermId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrMatrixTermAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrMatrixTermAudit] ADD CONSTRAINT [PK_TAtrMatrixTermAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrMatrixTermAudit_AtrMatrixTermId_ConcurrencyId] ON [dbo].[TAtrMatrixTermAudit] ([AtrMatrixTermId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
