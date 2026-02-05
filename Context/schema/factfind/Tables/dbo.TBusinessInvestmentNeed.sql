CREATE TABLE [dbo].[TBusinessInvestmentNeed]
(
[BusinessInvestmentNeedId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[GoalDescription] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[EstimatedCosts] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TBusiness__Concu__3E5D3103] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TBusinessInvestmentNeed_CRMContactId] ON [dbo].[TBusinessInvestmentNeed] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
