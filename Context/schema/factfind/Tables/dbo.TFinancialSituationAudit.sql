CREATE TABLE [dbo].[TFinancialSituationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DateEstablished] [datetime] NULL,
[FinancialYearEnd] [datetime] NULL,
[ApproxValue] [money] NULL,
[TotalInvestmentAssetValue] [money] NULL,
[TotalCollateralValue] [money] NULL,
[ValueIncreasingYesNo] [bit] NULL,
[Rate] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[FinancialSituationId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TFinancia__Concu__2EB0D91F] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialSituationAudit] ADD CONSTRAINT [PK_TFinancialSituationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
