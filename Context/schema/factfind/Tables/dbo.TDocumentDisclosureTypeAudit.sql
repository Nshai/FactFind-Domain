CREATE TABLE [dbo].[TDocumentDisclosureTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NULL,
[IndigoClientId] [int] NOT NULL,
[DocumentURL] [varchar] (MAX) NULL,
[DocumentDisclosureTypeId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDocumentDisclosureTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDocumentDisclosureTypeAudit] ADD CONSTRAINT [PK_TDocumentDisclosureTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
