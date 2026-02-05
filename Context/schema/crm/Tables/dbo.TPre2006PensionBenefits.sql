CREATE TABLE [dbo].[TPre2006PensionBenefits](
	[Pre2006PensionBenefitsId] [int] IDENTITY(1,1) NOT NULL,
	[CRMContactId] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[BenefitsInPaymentPre6thApril2006] [bit] NULL,
	[BenefitsTakenAfter5thApril2006] [bit] NULL,
	[DateOfBCE] [datetime] NULL,
	[TotalGrossAnnualIncome] [money] NULL,
	[CappedDrawdownMaximumIncome] [money] NULL,
	[IsConvertedToFAD] [bit] NULL,
	[DateConverted] [datetime] NULL,
	[MaxIncomePriorToConverting] [money] NULL
)
GO
ALTER TABLE [dbo].[TPre2006PensionBenefits] ADD CONSTRAINT [PK_TPre2006PensionBenefitsId] PRIMARY KEY ([Pre2006PensionBenefitsId])
GO
ALTER TABLE [dbo].[TPre2006PensionBenefits] ADD CONSTRAINT [FK_TPre2006PensionBenefits_CRMContactId] FOREIGN KEY ([CRMContactId])
REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TPre2006PensionBenefits_CRMContactId_TenantId] ON [dbo].[TPre2006PensionBenefits] ([CRMContactId], [TenantId])
GO