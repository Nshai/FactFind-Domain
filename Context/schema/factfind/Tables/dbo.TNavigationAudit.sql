CREATE TABLE [dbo].[TNavigationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ParentId] [int] NULL,
[Ordinal] [tinyint] NULL,
[Stylesheet] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FactFindTypeId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TNavigationAudit_ConcurrencyId] DEFAULT ((1)),
[NavigationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TNavigationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNavigationAudit] ADD CONSTRAINT [PK_TNavigationAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TNavigationAudit_NavigationId_ConcurrencyId] ON [dbo].[TNavigationAudit] ([NavigationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
