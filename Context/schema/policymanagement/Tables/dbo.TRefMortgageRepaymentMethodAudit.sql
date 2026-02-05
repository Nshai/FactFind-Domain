CREATE TABLE [dbo].[TRefMortgageRepaymentMethodAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MortgageRepaymentMethod] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefMortgageRepaymentMethodAudit_ConcurrencyId] DEFAULT ((1)),
[RefMortgageRepaymentMethodId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefMortgageRepaymentMethodAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefMortgageRepaymentMethodAudit] ADD CONSTRAINT [PK_TRefMortgageRepaymentMethodAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
