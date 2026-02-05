CREATE TABLE [dbo].[TFinancialSituationDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Year] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Turnover] [money] NULL,
[GrossProfit] [money] NULL,
[NetProfitBeforeTax] [money] NULL,
[TaxBill] [money] NULL,
[PAT] [money] NULL,
[CRMContactId] [int] NOT NULL,
[FinancialSituationDetailId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TFinancia__Concu__30992191] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialSituationDetailAudit] ADD CONSTRAINT [PK_TFinancialSituationDetailAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
