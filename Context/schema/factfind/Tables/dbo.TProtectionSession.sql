CREATE TABLE [dbo].[TProtectionSession]
(
	[ProtectionSessionId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [int] NOT NULL,
	[LastUpdateDateTime] [datetime] NOT NULL,
	[LastUpdateByUserId] [int] NOT NULL,
	[CompletedDateTime] [datetime] NULL,
	[ExpiryDateTime] [datetime] NOT NULL,
	[Description] [nvarchar](255) NULL,
	[PrimaryPartyId] [int] NOT NULL,
	[SecondaryPartyId] [int] NULL,
	[DisposabeIncomeAmount] [money],
	[BudgetAmount] [money] NULL,
	[StageComplete] [int] NOT NULL,
	[DocumentBinderId] [int] NULL

)

GO
ALTER TABLE [dbo].[TProtectionSession] ADD CONSTRAINT [PK_TProtectionSession] PRIMARY KEY CLUSTERED  ([ProtectionSessionId])
GO
CREATE NONCLUSTERED INDEX IX_TProtectionSession_TenantId_PrimaryPartyId ON [dbo].[TProtectionSession] ([TenantId], [PrimaryPartyId])
GO
CREATE NONCLUSTERED INDEX IX_TProtectionSession_TenantId_SecondaryPartyId ON [dbo].[TProtectionSession] ([TenantId], [SecondaryPartyId])
GO


        