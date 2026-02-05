CREATE TABLE [dbo].[TProvLinkAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NULL,
[LinkedToId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProvLinkA_ConcurrencyId_1__56] DEFAULT ((1)),
[ProvLinkId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProvLinkA_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProvLinkAudit] ADD CONSTRAINT [PK_TProvLinkAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TProvLinkAudit_ProvLinkId_ConcurrencyId] ON [dbo].[TProvLinkAudit] ([ProvLinkId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
