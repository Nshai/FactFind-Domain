CREATE TABLE [dbo].[TExpenditureDetail]
(
[ExpenditureDetailId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExpenditureDetail_ConcurrencyId] DEFAULT ((1)),
[ExpenditureId] [int] NULL,
[CRMContactId] [int] NULL,
[RefExpenditureTypeId] [int] NULL,
[NetMonthlyAmount] [money] NULL,
[IsConsolidated] [bit] NULL CONSTRAINT [DF_TExpenditureDetail_IsConsolidated] DEFAULT ((0)),
[IsLiabilityToBeRepaid] [bit] NULL CONSTRAINT [DF_TExpenditureDetail_IsLiabilityToBeRepaid] DEFAULT ((0)),
[UserDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Frequency] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId2] [int] NULL,
[PolicyBusinessId] [int] NULL,
[ContributionId] [int] NULL,
[StartDate] [date] NULL,
[EndDate] [date] NULL,
[NetAmount] [money] NULL
)
GO
ALTER TABLE [dbo].[TExpenditureDetail] ADD CONSTRAINT [PK_TExpenditureDetail] PRIMARY KEY NONCLUSTERED  ([ExpenditureDetailId])
GO
CREATE NONCLUSTERED INDEX [IDX_TExpenditureDetail_CRMContactId] ON [dbo].[TExpenditureDetail] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TExpenditureDetail_CRMContactId2] ON [dbo].[TExpenditureDetail] ([CRMContactId2]) WHERE CRMContactId2 IS NOT NULL
GO
