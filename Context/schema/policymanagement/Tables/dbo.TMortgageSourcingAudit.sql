CREATE TABLE [dbo].[TMortgageSourcingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationLinkId] [int] NOT NULL,
[IsSaveDocuments] [tinyint] NOT NULL CONSTRAINT [DF_TMortgageSourcingAudit_IsSaveDocuments] DEFAULT ((0)),
[DocumentCategoryId] [int] NULL,
[DocumentSubCategoryId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageSourcingAudit_ConcurrencyId] DEFAULT ((1)),
[MortgageSourcingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMortgageSourcingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageSourcingAudit] ADD CONSTRAINT [PK_TMortgageSourcingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMortgageSourcingAudit_MortgageSourcingId_ConcurrencyId] ON [dbo].[TMortgageSourcingAudit] ([MortgageSourcingId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
