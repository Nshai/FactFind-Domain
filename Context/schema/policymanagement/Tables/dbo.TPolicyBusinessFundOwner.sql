CREATE TABLE [dbo].[TPolicyBusinessFundOwner]
(
[PolicyBusinessFundOwnerId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessFundId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[PercentageHeld] [decimal] (18, 2) NOT NULL,
[FundType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessFundOwner_ConcurrencyId] DEFAULT ((0))
)
GO
