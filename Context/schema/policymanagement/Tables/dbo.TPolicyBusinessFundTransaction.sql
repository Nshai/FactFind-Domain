USE [PolicyManagement]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TPolicyBusinessFundTransaction]
(
	[PolicyBusinessFundTransactionId] [bigint] NOT NULL 
		CONSTRAINT [DF_TPolicyBusinessFundTransaction_PolicyBusinessFundTransactionId] 
		DEFAULT(NEXT VALUE FOR [dbo].[SEQ_PolicyBusinessTransactionId]),
	[PolicyBusinessFundId] [int] NOT NULL,
	[TransactionDate] [datetime] NULL,
	[RefFundTransactionTypeId] [int] NULL,
	[Gross] [money] NOT NULL,
	[Cost] [money] NULL 
		CONSTRAINT [DF_TPolicyBusinessFundTransaction_Cost] DEFAULT ((0)),
	[UnitPrice] [money] NULL,
	[UnitQuantity] [money] NULL,
	[ConcurrencyId] [int] NULL 
		CONSTRAINT [DF_TPolicyBusinessFundTransaction_ConcurrencyId] DEFAULT ((1)),
	[IsFromTransactionHistory] [bit] NULL,
	[MigrationReference] [varchar] (255) NULL,
	[Description] [varchar] (255) NULL,
	[TenantId] [int] NOT NULL,
	[PolicyBusinessId] [int] NULL,
	[BaseType] [varchar](2) NULL 
		CONSTRAINT [CHK_TPolicyBusinessFundTransaction_BaseType] 
		CHECK (BaseType IS NULL OR BaseType IN ('CR','DR')),
	[EntryType] [varchar](20) NULL 
		CONSTRAINT [CHK_TPolicyBusinessFundTransaction_Type] 
		CHECK (EntryType IS NULL OR EntryType in ('Income', 'Expense', 'TransferIn', 'TransferOut')),
	[Category1Text] [varchar] (50) NULL,
	[Category1Code] [varchar](10) NULL,
	[Category2Text] [varchar](50) NULL,
	[Category2Code] [varchar](10) NULL,
	[PaymentFrom] [varchar](50) NULL,
	[PaymentTo] [varchar](50) NULL,
	[Frequency] [varchar](20) NULL ,
		CONSTRAINT [CHK_TPolicyBusinessFundTransaction_Frequency] 
		CHECK (Frequency IS NULL OR Frequency IN ('None', 'Weekly', 'Fortnightly', 'FourWeekly', 'Monthly', 'Quarterly', 'HalfYearly', 'Annually', 'Single', 'Termly')),
	[Reference] [varchar](50) NULL,
	[IsRestricted] [bit] NULL 
		CONSTRAINT [DF_TPolicyBusinessFundTransaction_IsRestricted] DEFAULT((0)),
	[CreatedAt] [datetime2] NULL 
		CONSTRAINT [DF_TPolicyBusinessFundTransaction_CreatedAt] DEFAULT (GetUtcDate()),
	[CreatedByUserId] [int] NULL,
	[CreatedByAppId] [varchar](100) NULL,
	[CreatedByAppName] [varchar](255) NULL,
	[UpdatedAt] [datetime2] NULL
		CONSTRAINT [DF_TPolicyBusinessFundTransaction_UpdatedAt] DEFAULT (GetUtcDate()),
	[UpdatedByUserId] [int] NULL,
	CONSTRAINT [PK_TPolicyBusinessFundTransaction_PolicyBusinessFundTransactionId] PRIMARY KEY CLUSTERED 
	(
		[PolicyBusinessFundTransactionId] ASC,
		[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
--ON [ps_TPolicyBusinessFundTransaction_TenantId]([TenantId])
) 
--ON ps_TPolicyBusinessFundTransaction_TenantId(TenantId)
GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TPolicyBusinessFundTransaction] SET (LOCK_ESCALATION = AUTO)
GO

CREATE NONCLUSTERED INDEX [IX_TPolicyBusinessFundTransaction_PolicyBusinessFundId_UnitQuantity_TransactionDate_UnitPrice_TenantId] ON [dbo].[TPolicyBusinessFundTransaction]
(
	[PolicyBusinessFundId] ASC,
	[UnitQuantity] ASC,
	[TransactionDate] ASC,
	[UnitPrice] ASC,
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--ON ps_TPolicyBusinessFundTransaction_TenantId(TenantId)
GO

ALTER TABLE [dbo].[TPolicyBusinessFundTransaction]  
WITH CHECK ADD CONSTRAINT [FK_TPolicyBusinessFundTransaction_RefFundTransactionTypeId] 
FOREIGN KEY([RefFundTransactionTypeId]) REFERENCES [dbo].[TRefFundTransactionType] ([RefFundTransactionTypeId])
GO

ALTER TABLE [dbo].[TPolicyBusinessFundTransaction] 
WITH CHECK ADD CONSTRAINT [FK_TPolicyBusinessFundTransaction_TPolicyBusinessFund] 
FOREIGN KEY ([PolicyBusinessFundId]) REFERENCES [dbo].[TPolicyBusinessFund] ([PolicyBusinessFundId])
GO
