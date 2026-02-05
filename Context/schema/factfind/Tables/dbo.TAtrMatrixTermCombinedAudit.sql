CREATE TABLE [dbo].[TAtrMatrixTermCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrMatrixTermId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Starting] [tinyint] NULL,
[Ending] [tinyint] NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TAtrMatrixTermCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[Guid] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrMatrixTermCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrMatrixTermCombinedAudit] ADD CONSTRAINT [PK_TAtrMatrixTermCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrMatrixTermCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TAtrMatrixTermCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
