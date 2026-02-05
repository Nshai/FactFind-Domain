CREATE TABLE [dbo].[TQVTLinkAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NULL,
[ProductId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[QVTLinkId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQVTLinkAu_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQVTLinkAudit] ADD CONSTRAINT [PK_TQVTLinkAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TQVTLinkAudit_QVTLinkId_ConcurrencyId] ON [dbo].[TQVTLinkAudit] ([QVTLinkId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
