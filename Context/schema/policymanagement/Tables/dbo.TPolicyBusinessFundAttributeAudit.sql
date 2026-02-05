CREATE TABLE [dbo].[TPolicyBusinessFundAttributeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessFundId] [int] NOT NULL,
[RefFundAttributeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessFundAttributeAudit_ConcurrencyId] DEFAULT ((1)),
[PolicyBusinessFundAttributeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBusinessFundAttributeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessFundAttributeAudit] ADD CONSTRAINT [PK_TPolicyBusinessFundAttributeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
