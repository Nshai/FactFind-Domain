CREATE TABLE [dbo].[TDocumentDisclosure]
(
[DocumentDisclosureId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDocumentDisclosure_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[DocumentDisclosureTypeId] [int] NOT NULL,
[IssueDate] [datetime] NULL,
[IsClientPresent] [bit] NULL
)
GO
ALTER TABLE [dbo].[TDocumentDisclosure] ADD CONSTRAINT [PK_TDocumentDisclosure] PRIMARY KEY NONCLUSTERED  ([DocumentDisclosureId])
GO
CREATE CLUSTERED INDEX [IDX_TDocumentDisclosure_CRMContactId] ON [dbo].[TDocumentDisclosure] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
