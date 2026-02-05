CREATE TABLE [dbo].[TFinancialPlanningStatePensionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[RefPensionForecastId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningStatePensionAudit_RefPensionForecastId] DEFAULT ((1)),
[BasicAnnualAmount] [money] NOT NULL CONSTRAINT [DF_TFinancialPlanningStatePensionAudit_BasicAnnualAmount] DEFAULT ((0)),
[AdditionalAnnualAmount] [money] NOT NULL CONSTRAINT [DF_TFinancialPlanningStatePensionAudit_AdditionalAnnualAmount] DEFAULT ((0)),
[TaxYearStartWork] [int] NULL,
[TaxYearFinishWork] [int] NULL,
[AnnualSalary] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningStatePensionAudit_ConcurrencyId] DEFAULT ((0)),
[FinancialPlanningStatePensionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningStatePensionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningStatePensionAudit] ADD CONSTRAINT [PK_TFinancialPlanningStatePensionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
