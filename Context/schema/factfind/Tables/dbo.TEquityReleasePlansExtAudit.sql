CREATE TABLE [dbo].[TEquityReleasePlansExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[PropertyAddress] [int] NULL,
[RepaymentMethod] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AmountReleased] [money] NULL,
[InterestRate] [decimal] (10, 2) NULL,
[LinkedToAsset] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEquityReleasePlansExtAudit_ConcurrencyId] DEFAULT ((1)),
[EquityReleasePlansExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEquityReleasePlansExtAudit] ADD CONSTRAINT [PK_TEquityReleasePlansExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TEquityReleasePlansExtAudit_EquityReleasePlansExtId_ConcurrencyId] ON [dbo].[TEquityReleasePlansExtAudit] ([EquityReleasePlansExtId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
