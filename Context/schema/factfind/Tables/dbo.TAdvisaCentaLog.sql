CREATE TABLE [dbo].[TAdvisaCentaLog]
(
[AdvisaCentaLogId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningSessionId] [int] NOT NULL,
[Method] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[IsRequest] [bit] NOT NULL,
[Message] [xml] NULL,
[Exception] [xml] NULL,
[CreatedDate] [datetime] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdvisaCentaLog_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdvisaCentaLog] ADD CONSTRAINT [PK_TAdvisaCentaLog] PRIMARY KEY CLUSTERED  ([AdvisaCentaLogId] , [CreatedDate])
GO
