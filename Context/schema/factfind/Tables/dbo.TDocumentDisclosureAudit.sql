CREATE TABLE [dbo].[TDocumentDisclosureAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DocumentDisclosureId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[DocumentDisclosureTypeId] [int] NOT NULL,
[IssueDate] [datetime] NULL,
[IsClientPresent] [bit] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDocumentDisclosureAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDocumentDisclosureAudit] ADD CONSTRAINT [PK_TDocumentDisclosureAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
