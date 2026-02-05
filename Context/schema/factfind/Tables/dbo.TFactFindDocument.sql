CREATE TABLE [dbo].[TFactFindDocument]
(
[FactFindDocumentId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FactFindDocumentTypeId] [int] NOT NULL,
[DocVersionId] [int] NOT NULL,
[CrmContactId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TFactFindDocument_CreatedDate] DEFAULT (getdate()),
[Creator] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsFull] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindDocument_ConcurrencyId] DEFAULT ((1)),
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFactFindDocument] ADD CONSTRAINT [PK_TFactFindDocument] PRIMARY KEY NONCLUSTERED  ([FactFindDocumentId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TFactFindDocument_CRMContactId] ON [dbo].[TFactFindDocument] ([CrmContactId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IX_TFactFindDocument_CRMContactId] ON [dbo].[TFactFindDocument] ([CrmContactId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TFactFindDocument_DocVersionId] ON [dbo].[TFactFindDocument] ([DocVersionId])
GO
CREATE NONCLUSTERED INDEX [IX_TFactFindDocument_MigrationRef_IndigoClientId] ON [dbo].[TFactFindDocument] ([MigrationRef])
GO