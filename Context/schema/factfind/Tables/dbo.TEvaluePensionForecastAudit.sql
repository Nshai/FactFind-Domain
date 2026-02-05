CREATE TABLE [dbo].[TEvaluePensionForecastAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EValueLogId] [int] NULL,
[TaxYearStart] [int] NULL,
[TaxYearEnd] [int] NULL,
[EvaluePensionForecastXML] [xml] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvaluePensionForecastAudit_ConcurrencyId] DEFAULT ((1)),
[EvaluePensionForecastId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvaluePensionForecastAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvaluePensionForecastAudit] ADD CONSTRAINT [PK_TEvaluePensionForecastAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvaluePensionForecastAudit_EvaluePensionForecastId_ConcurrencyId] ON [dbo].[TEvaluePensionForecastAudit] ([EvaluePensionForecastId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
