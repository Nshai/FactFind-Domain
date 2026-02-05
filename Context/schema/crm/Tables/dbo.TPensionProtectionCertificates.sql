CREATE TABLE [dbo].[TPensionProtectionCertificates](
	[PensionProtectionCertificatesId] [int] IDENTITY(1,1) NOT NULL,
	[CRMContactId] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[TypeOfProtection] [int] NOT NULL,
	[ProtectionReferenceNumber] [varchar] (100) NULL,
	[PensionSchemeAdministratorNumber] [varchar] (100) NULL,
	[ValueOfUncrystallisedRights] [money] NULL,
	[EnhancementFactor] [money] NULL,
	[ProtectedAmount] [money] NULL,
	[LumpSumProtection] [bit] NULL,
	[PercentProtectedLumpSum] [money] NULL,
	[ProtectedValue] [money] NULL,
	[AmountProtectedLumpSum] [money] NULL
)
GO
ALTER TABLE [dbo].[TPensionProtectionCertificates]
ADD CONSTRAINT [PK_TPensionProtectionCertificatesId] PRIMARY KEY ([PensionProtectionCertificatesId])
GO
ALTER TABLE [dbo].[TPensionProtectionCertificates]
ADD CONSTRAINT [FK_TPensionProtectionCertificates_CRMContactId] FOREIGN KEY ([CRMContactId])
REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TPensionProtectionCertificates_CRMContactId_TenantId]
ON [dbo].[TPensionProtectionCertificates] ([CRMContactId], [TenantId])
GO
