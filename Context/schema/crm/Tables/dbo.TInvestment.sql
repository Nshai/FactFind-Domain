CREATE TABLE [dbo].[TInvestment]
(
[InvestmentId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32)  NOT NULL,
[Capital] [int] NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_Investment_Concurrency] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TInvestment] ADD CONSTRAINT [PK_TInvestment_InvestmentId] PRIMARY KEY CLUSTERED  ([InvestmentId])
GO
ALTER TABLE [dbo].[TInvestment] WITH CHECK ADD CONSTRAINT [FK_TInvestment_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
