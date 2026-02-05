CREATE TABLE [dbo].[TAdvisaCentaErrorLog]
(
[AdvisaCentaErrorLogId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningSessionId] [int] NULL,
[IoMessage] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[Exception] [xml] NULL,
[CreatedDate] [datetime] NOT NULL,
[UserId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdvisaCentaErrorLog_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdvisaCentaErrorLog] ADD CONSTRAINT [PK_TAdvisaCentaErrorLog] PRIMARY KEY CLUSTERED  ([AdvisaCentaErrorLogId])
GO
