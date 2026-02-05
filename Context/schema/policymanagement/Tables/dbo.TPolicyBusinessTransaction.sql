CREATE TABLE [dbo].[TPolicyBusinessTransaction]
(
	 [PolicyBusinessTransactionId] [bigint] NOT NULL 
		CONSTRAINT [DF_TPolicyBusinessTransaction_PK] DEFAULT(NEXT VALUE FOR [dbo].[SEQ_PolicyBusinessTransactionId])
	,[TenantId] [int] NOT NULL 
	,[PolicyBusinessId] [int] NULL
	,[PolicyBusinessFundId] [int] NULL 
	,[TransactionDate] [datetime2] NULL
	,[Source] [varchar](10) NOT NULL 
		 CONSTRAINT [DF_TPolicyBusinessTransaction_Source] 
		 DEFAULT (('Fund')) -- do this initially until TPolicyBusinessFundTransaction is migrated
		,CONSTRAINT [CHK_TPolicyBusinessTransaction_Source] 
		 CHECK ( Source IN ('Fund', 'Plan'))
	,[BaseType] [varchar](2) NULL 
		CONSTRAINT [CHK_TPolicyBusinessTransaction_BaseType] 
		CHECK (BaseType IS NULL OR BaseType IN ('CR','DR'))
	,[EntryType] [varchar](20) NULL 
		CONSTRAINT [CHK_TPolicyBusinessTransaction_Type] 
		CHECK (EntryType IS NULL OR EntryType in ('Income', 'Expense', 'TransferIn', 'TransferOut'))
	,[Description] [varchar] (255) NULL
	,[Gross] [money] NOT NULL
	,[Cost] [money] NULL 
		CONSTRAINT [DF_TPolicyBusinessTransaction_Cost] DEFAULT ((0))
	,[UnitPrice] [money] NULL
	,[UnitQuantity] [money] NULL
	,[Category1Text] [varchar](50) NULL
	,[Category1Code] [varchar](10) NULL
	,[Category2Text] [varchar](50) NULL
	,[Category2Code] [varchar](10) NULL
	,[PaymentFrom] [varchar](50) NULL
	,[PaymentTo] [varchar](50) NULL
	,[Frequency] [varchar](20) NULL 
		CONSTRAINT [CHK_TPolicyBusinessTransaction_Frequency] 
		CHECK (Frequency IS NULL OR Frequency IN ('None', 'Weekly', 'Fortnightly', 'FourWeekly', 'Monthly', 'Quarterly', 'HalfYearly', 'Annually', 'Single', 'Termly'))
	,[Reference] [varchar](50) NULL
	,[IsRestricted] [bit] NOT NULL 
		CONSTRAINT [DF_TPolicyBusinessTransaction_IsRestricted] DEFAULT((0))
	,[RefFundTransactionTypeId] [int] NULL -- to be deprecated - included to ease migration of fund transactions
	,[IsFromTransactionHistory] [bit] NULL
	,[MigrationReference] [varchar] (255) NULL
	,[CreatedByUserId] [int] NULL
	,[CreatedByAppId] [varchar](100) NULL
	,[CreatedByAppName] [varchar](255) NULL
	,[CreatedAt] [datetime2] NOT NULL 
		CONSTRAINT [DF_TPolicyBusinessTransaction_CreatedAt] DEFAULT(GetUtcDate())
    ,[UpdatedByUserId] [int] NULL
	,[UpdatedAt] [datetime2] NOT NULL 
		CONSTRAINT [DF_TPolicyBusinessTransaction_UpdatedAt] DEFAULT(GetUtcDate())
)
GO

ALTER TABLE 
	[dbo].[TPolicyBusinessTransaction] 
ADD CONSTRAINT 
	[PK_TPolicyBusinessTransaction_PolicyBusinessTransactionId] 
PRIMARY KEY CLUSTERED  
	([TenantId],[PolicyBusinessTransactionId]) 
GO

CREATE NONCLUSTERED INDEX 
	[IX_TPolicyBusinessTransaction_PolicyBusinessFundId] 
ON 
	[dbo].[TPolicyBusinessTransaction] ([PolicyBusinessFundId]) 
GO

CREATE NONCLUSTERED INDEX 
	[IX_TPolicyBusinessTransaction_PolicyBusinessId] 
ON 
	[dbo].[TPolicyBusinessTransaction] ([PolicyBusinessId])
GO

ALTER TABLE 
	[dbo].[TPolicyBusinessTransaction] 
ADD CONSTRAINT 
	[FK_TPolicyBusinessTransaction_TPolicyBusinessFund] 
FOREIGN KEY 
	([PolicyBusinessFundId]) 
REFERENCES 
	[dbo].[TPolicyBusinessFund] ([PolicyBusinessFundId])
GO

ALTER TABLE 
	[dbo].[TPolicyBusinessTransaction] 
ADD CONSTRAINT 
	[FK_TPolicyBusinessTransaction_TPolicyBusiness] 
FOREIGN KEY 
	([PolicyBusinessId]) 
REFERENCES 
	[dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO

ALTER TABLE 
	[dbo].[TPolicyBusinessTransaction] 
ADD CONSTRAINT 
	[FK_TPolicyBusinessTransaction_RefFundTransactionTypeId_RefFundTransactionTypeId] 
FOREIGN KEY 
	([RefFundTransactionTypeId]) 
REFERENCES 
	[dbo].[TRefFundTransactionType] ([RefFundTransactionTypeId])
GO

CREATE NONCLUSTERED INDEX 
	IX_TPolicyBusinessTransaction_RefFundTransactionTypeId 
ON 
	[dbo].[TPolicyBusinessTransaction] ([RefFundTransactionTypeId]) 
INCLUDE 
	([PolicyBusinessFundId]) 
GO

CREATE NONCLUSTERED INDEX 
	IX_TPolicyBusinessTransaction_PolicyBusinessFundId_TransactionDate_RefFundTransactionTypeId 
ON 
	[dbo].[TPolicyBusinessTransaction]
	(
		 PolicyBusinessFundId
		,TransactionDate
		,RefFundTransactionTypeId
	)
GO

CREATE NONCLUSTERED INDEX 
	IX_TPolicyBusinessTransaction_PolicyBusinessFundId_UnitQuantity_TransactionDate_UnitPrice 
ON 
	[dbo].[TPolicyBusinessTransaction] 
	(
		 PolicyBusinessFundId
		,UnitQuantity
		,TransactionDate
		,UnitPrice
	)
GO

ALTER TABLE 
	[dbo].[TPolicyBusinessTransaction] 
SET 
	( LOCK_ESCALATION = DISABLE )
GO