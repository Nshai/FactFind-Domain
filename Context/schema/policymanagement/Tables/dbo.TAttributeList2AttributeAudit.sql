CREATE TABLE [dbo].[TAttributeList2AttributeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AttributeListId] [int] NOT NULL,
[AttributeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAttribute_ConcurrencyId_3__56] DEFAULT ((1)),
[AttributeList2AttributeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAttribute_StampDateTime_4__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAttributeList2AttributeAudit] ADD CONSTRAINT [PK_TAttributeList2AttributeAudit_5__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TAttributeList2AttributeAudit_AttributeList2AttributeId_ConcurrencyId] ON [dbo].[TAttributeList2AttributeAudit] ([AttributeList2AttributeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
