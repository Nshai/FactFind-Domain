CREATE TABLE [dbo].[TAsuQuoteClientAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAsuQuoteClientAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[QuoteClientId] [int] NULL,
[Age] [int] NULL,
[DateAgeCalculated] [datetime] NULL,
[ClientRequired] [bit] NULL,
[GrossMonthlyIncome] [decimal] (10, 4) NULL,
[Aged18To64] [int] NULL,
[LivingUk16Hours] [int] NULL,
[TemporaryWork] [int] NULL,
[NamedOnMortgage] [int] NULL,
[ResidentialMortagage] [int] NULL,
[PaymentsUptoDate] [int] NULL,
[AwareOfClaim] [int] NULL,
[ExtraInfoClaim] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[FormalNotificationOrCuts] [int] NULL,
[FormalAdministrationOrLiquidation] [int] NULL,
[RegisteredUnemployed] [nvarchar] (200) COLLATE Latin1_General_CI_AS NULL,
[ContinuosEmployment] [nvarchar] (200) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAsuQuoteClientAudit] ADD CONSTRAINT [PK_TAsuQuoteClientAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
