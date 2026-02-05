CREATE TABLE [dbo].[TAttributeListAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Type] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAttribute_ConcurrencyId_2__56] DEFAULT ((1)),
[AttributeListId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAttribute_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAttributeListAudit] ADD CONSTRAINT [PK_TAttributeListAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TAttributeListAudit_AttributeListId_ConcurrencyId] ON [dbo].[TAttributeListAudit] ([AttributeListId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
