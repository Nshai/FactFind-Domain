CREATE TABLE [dbo].[TPlanTypeExceptionToNewRiskProfileAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[PlanTypeExceptionToRiskProfileId] [int] NULL,
	[PlanTypeExceptionId] [int] NULL,
	[AtrTemplateId] [int] NULL,
	[RiskProfileId] [varchar](111) NULL,
	[TenantId] [int] NULL,
	[ConcurrencyId] [int] NULL,
	[StampAction] [char](1) NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](50) NULL,
 CONSTRAINT [PK_TPlanTypeExceptionToNewRiskProfileAudit] PRIMARY KEY CLUSTERED ([AuditId] ASC)
) 
GO
