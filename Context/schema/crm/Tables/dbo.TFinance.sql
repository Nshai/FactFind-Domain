CREATE TABLE [dbo].[TFinance]
(
[FinanceId] [int] NOT NULL IDENTITY(1, 1),
[Status] [varchar] (16)  NULL,
[Stability] [varchar] (16)  NULL,
[Earned] [money] NULL,
[Investment] [money] NULL,
[Tax] [money] NULL,
[Expenditure] [money] NULL,
[Possessions] [money] NULL,
[PropertyOwner] [bit] NOT NULL CONSTRAINT [DF_TFinance_PropertyOwner] DEFAULT ((0)),
[PropertyStatus] [varchar] (32)  NULL,
[Ethical] [bit] NULL,
[CrmContactId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinance_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinance] ADD CONSTRAINT [PK_TFinance_FinanceId] PRIMARY KEY CLUSTERED  ([FinanceId])
GO
ALTER TABLE [dbo].[TFinance] WITH CHECK ADD CONSTRAINT [FK_TFinance_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
