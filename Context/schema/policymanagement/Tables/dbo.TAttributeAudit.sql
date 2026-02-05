CREATE TABLE [dbo].[TAttributeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Value] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAttribute_ConcurrencyId_1__56] DEFAULT ((1)),
[AttributeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAttribute_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAttributeAudit] ADD CONSTRAINT [PK_TAttributeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TAttributeAudit_AttributeId_ConcurrencyId] ON [dbo].[TAttributeAudit] ([AttributeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
