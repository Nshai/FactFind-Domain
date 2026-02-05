CREATE TABLE [dbo].[TRefAverageVolatilityReturnAudit]
(
[AuditId] [bigint] NOT NULL IDENTITY(1, 1),
[RefAverageVolatilityReturnId] [bigint] NOT NULL,
[RiskProfileId] [bigint] NULL,
[Term] [bigint] NULL,
[AverageVolatilityReturn] [decimal] (18, 10) NULL,
[ConcurrencyId] [bigint] NULL,
[ATRTemplateGuid] [uniqueidentifier] NULL,
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
