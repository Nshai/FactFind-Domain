CREATE TABLE [dbo].[TRefProductLinkAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationLinkId] [int] NULL,
[RefProductTypeId] [int] NOT NULL,
[ProductGroupData] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ProductTypeData] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefProductLinkAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefProductLinkAudit_ConcurrencyId] DEFAULT ((1)),
[RefProductLinkId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefProductLinkAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefProductLinkAudit] ADD CONSTRAINT [PK_TRefProductLinkAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefProductLinkAudit_RefProductLinkId_ConcurrencyId] ON [dbo].[TRefProductLinkAudit] ([RefProductLinkId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
