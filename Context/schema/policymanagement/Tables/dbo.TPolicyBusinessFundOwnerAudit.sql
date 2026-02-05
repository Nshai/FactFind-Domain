CREATE TABLE [dbo].[TPolicyBusinessFundOwnerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessFundId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[PercentageHeld] [decimal] (18, 2) NOT NULL,
[FundType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[PolicyBusinessFundOwnerId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessFundOwnerAudit] ADD CONSTRAINT [PK_TPolicyBusinessFundOwnerAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
