CREATE TABLE [dbo].[TInvestmentCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[OrderNbr] [int] NULL,
[ChartSeriesColour] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentCategoryAudit_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL,
[InvestmentCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentCategoryAudit] ADD CONSTRAINT [PK_TInvestmentCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
