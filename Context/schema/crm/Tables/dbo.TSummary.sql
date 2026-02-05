CREATE TABLE [dbo].[TSummary]
(
[SummaryId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32)  NOT NULL,
[Property] [varchar] (32)  NOT NULL,
[Comment] [varchar] (512)  NULL,
[TargetIncome] [money] NULL,
[TargetLumpSum] [money] NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSummary_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSummary] ADD CONSTRAINT [PK_TSummary_SummaryId] PRIMARY KEY CLUSTERED  ([SummaryId])
GO
ALTER TABLE [dbo].[TSummary] WITH CHECK ADD CONSTRAINT [FK_TSummary_CrmContactId_CrmContactId] FOREIGN KEY ([CrmContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
