CREATE TABLE [dbo].[TPolicyBusinessFundAttributeMaskAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessFundId] [int] NOT NULL,
[AttributeMask] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PolicyBusinessFundAttributeMaskId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessFundAttributeMaskAudit] ADD CONSTRAINT [PK_TPolicyBusinessFundAttributeMaskAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
