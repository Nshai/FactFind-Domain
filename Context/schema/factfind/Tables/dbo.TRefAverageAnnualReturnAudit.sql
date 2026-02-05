CREATE TABLE [dbo].[TRefAverageAnnualReturnAudit]
(
[AuditId] [bigint] NOT NULL IDENTITY(1, 1),
[RefAverageAnnualReturnId] [bigint] NOT NULL,
[RiskProfileId] [int] NULL,
[Term] [int] NULL,
[AverageAnnualReturn] [decimal] (18, 10) NULL,
[ConcurrencyId] [bigint] NULL,
[ATRTemplateGuid] [uniqueidentifier] NULL,
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
