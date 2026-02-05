CREATE TABLE [dbo].[TPlanTypeExceptionToNewRiskProfile](
	[PlanTypeExceptionToRiskProfileId] [int] IDENTITY(1,1) NOT NULL,
	[PlanTypeExceptionId] [int] NOT NULL,
	[RiskProfileId] [varchar](111) NOT NULL,
	[AtrTemplateId] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ConcurrencyId] [int] NULL CONSTRAINT [DF_TPlanTypeExceptionToNewRiskProfile_ConcurrencyId] DEFAULT ((1)),
	[PlanTypeExceptionToRiskProfileMigrationId] [int] NULL,
	CONSTRAINT [PK_TPlanTypeExceptionToNewRiskProfile] PRIMARY KEY CLUSTERED ([PlanTypeExceptionToRiskProfileId] ASC) 
)
GO

ALTER TABLE [dbo].[TPlanTypeExceptionToNewRiskProfile]  WITH CHECK ADD  CONSTRAINT [FK_TPlanTypeExceptionToNewRiskProfile_TPlanTypeException] FOREIGN KEY([PlanTypeExceptionId])
REFERENCES [dbo].[TPlanTypeException] ([PlanTypeExceptionId])
GO

CREATE NONCLUSTERED INDEX [Index_PlanTypeExceptionId] ON [dbo].[TPlanTypeExceptionToNewRiskProfile] ([PlanTypeExceptionId])
GO

ALTER TABLE [dbo].[TPlanTypeExceptionToNewRiskProfile] CHECK CONSTRAINT [FK_TPlanTypeExceptionToNewRiskProfile_TPlanTypeException]
GO