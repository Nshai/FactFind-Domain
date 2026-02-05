CREATE TABLE [dbo].[TFinancialProfile](
	[FinancialProfileId] [int] IDENTITY(1,1) NOT NULL,
	[TenantId] [int] NOT NULL,
	[CrmContactId] [int] NOT NULL,
	[ModifiedByUserId] [int] NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[TaxBracket] [decimal](10, 2) NULL,
	[IsSubjectToBackupWithholding] [bit] NULL,
	[TotalGrossAnnualIncome] [money] NULL,
	[TotalNetWorth] [money] NULL,
	[TotalLiquidNetWorth] [money] NULL,
	[HouseholdIncome] [money] NULL,
	[HouseholdNetWorth] [money] NULL,
	[HouseholdLiquidNetWorth] [money] NULL,
	[MPAATriggeredAt] [datetime] NULL
 CONSTRAINT [PK_TFinancialProfile_TenantId_CrmContactId] PRIMARY KEY CLUSTERED 
(
	[TenantId] ASC,
	[CrmContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TFinancialProfile] WITH CHECK ADD CONSTRAINT [FK_TFinancialProfile_CrmContactId_CrmContactId] FOREIGN KEY([CrmContactId])
REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO