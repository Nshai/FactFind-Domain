CREATE TABLE [dbo].[TEquityReleasePlansExt]
(
[EquityReleasePlansExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[PropertyAddress] [int] NULL,
[RepaymentMethod] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AmountReleased] [money] NULL,
[InterestRate] [decimal] (10, 2) NULL,
[LinkedToAsset] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEquityReleasePlansExt_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEquityReleasePlansExt] ADD CONSTRAINT [PK_TEquityReleasePlansExt] PRIMARY KEY NONCLUSTERED  ([EquityReleasePlansExtId]) WITH (FILLFACTOR=80)
GO
