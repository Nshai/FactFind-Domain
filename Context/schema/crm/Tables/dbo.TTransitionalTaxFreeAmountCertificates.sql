CREATE TABLE [dbo].[TTransitionalTaxFreeAmountCertificate](
	[TransitionalTaxFreeAmountCertificateId] [int] IDENTITY(1,1) NOT NULL,
	[CRMContactId] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[IsCertificateExists] [bit] NOT NULL,
	[LumpSumAmount] [money] NULL,
	[LumpSumAndDeathBenefitAmount] [money] NULL
)
GO
ALTER TABLE [dbo].[TTransitionalTaxFreeAmountCertificate] ADD CONSTRAINT [PK_TransitionalTaxFreeAmountCertificateId] PRIMARY KEY ([TransitionalTaxFreeAmountCertificateId])
GO
ALTER TABLE [dbo].[TTransitionalTaxFreeAmountCertificate] ADD CONSTRAINT [FK_TTransitionalTaxFreeAmountCertificate_CRMContactId] FOREIGN KEY ([CRMContactId])
REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TTransitionalTaxFreeAmountCertificate_CRMContactId_TenantId] ON [dbo].[TTransitionalTaxFreeAmountCertificate] ([CRMContactId], [TenantId])
GO