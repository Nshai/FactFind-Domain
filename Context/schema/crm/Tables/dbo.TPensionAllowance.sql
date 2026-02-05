CREATE TABLE [dbo].[TPensionAllowance](
	[PensionAllowanceId] [int] IDENTITY(1,1) NOT NULL,
	[CrmContactId] [int] NOT NULL,
	[Date] [datetime] NULL,
	[RefLumpSumTypeId] [int] NULL,
	[LumpSumAllowanceAmount] [money] NULL,
	[LumpSumDeathBenefitAmount] [money] NULL,
	[CrystallisedAmount] [money] NULL,
	[RelatedNonRegisteredPlan] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
	[RelatedPlanId] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TPensionAllowance] WITH CHECK ADD CONSTRAINT [FK_TPensionAllowance_CrmContactId] FOREIGN KEY([CrmContactId])
REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TPensionAllowance] WITH CHECK ADD CONSTRAINT [FK_TRefLumpSumType_TRefLumpSumType] FOREIGN KEY ([RefLumpSumTypeId])
REFERENCES [dbo].[TRefLumpSumType] ([RefLumpSumTypeId])
GO