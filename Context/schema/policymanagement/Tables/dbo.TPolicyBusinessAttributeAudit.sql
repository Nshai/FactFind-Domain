CREATE TABLE [dbo].[TPolicyBusinessAttributeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PolicyBusinessId] [int] NOT NULL,
[AttributeList2AttributeId] [int] NULL,
[AttributeValue] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBus_ConcurrencyId_1__56] DEFAULT ((1)),
[PolicyBusinessAttributeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBus_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessAttributeAudit] ADD CONSTRAINT [PK_TPolicyBusinessAttributeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyBusinessAttributeAudit_PolicyBusinessAttributeId_ConcurrencyId] ON [dbo].[TPolicyBusinessAttributeAudit] ([PolicyBusinessAttributeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessAttributeAudit_PolicyBusinessId] ON [dbo].[TPolicyBusinessAttributeAudit] ([PolicyBusinessId]) WITH (FILLFACTOR=80)
GO
