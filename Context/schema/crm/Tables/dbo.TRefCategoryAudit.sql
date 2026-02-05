CREATE TABLE [dbo].[TRefCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefCatego_StampDateTime_1__54] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCategoryAudit] ADD CONSTRAINT [PK_TRefCategoryAudit_2__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefCategoryAudit_RefCategoryId_ConcurrencyId] ON [dbo].[TRefCategoryAudit] ([RefCategoryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
