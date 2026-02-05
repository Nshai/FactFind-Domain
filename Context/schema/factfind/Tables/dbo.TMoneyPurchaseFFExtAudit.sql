CREATE TABLE [dbo].[TMoneyPurchaseFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NonDisclosure] [bit] NULL,
[ExistingMoneyPurchaseSchemes] [bit] NULL,
[SSPContractedOut] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[MoneyPurchaseFFExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMoneyPurchaseFFExtAudit] ADD CONSTRAINT [PK_TMoneyPurchaseFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
