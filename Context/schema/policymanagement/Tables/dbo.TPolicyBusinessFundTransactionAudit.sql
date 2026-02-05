CREATE TABLE [dbo].[TPolicyBusinessFundTransactionAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1,1),
	[PolicyBusinessFundId] [int] NOT NULL,
	[TransactionDate] [datetime] NULL,
	[RefFundTransactionTypeId] [int] NULL,
	[Gross] [money] NOT NULL,
	[Cost] [money] NULL CONSTRAINT [DF_TPolicyBusinessFundTransactionAudit_Cost] DEFAULT ((0)),
	[UnitPrice] [money] NULL,
	[UnitQuantity] [money] NULL,
	[ConcurrencyId] [int] NULL CONSTRAINT [DF_TPolicyBusinessFundTransactionAudit_ConcurrencyId] DEFAULT ((1)),
	[PolicyBusinessFundTransactionId] [bigint] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBusinessFundTransactionAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) NULL,
	[IsFromTransactionHistory] [bit] NULL,
	[MigrationReference] [varchar](255) NULL,
	[Description] [varchar](255) NULL,
	TenantId INT NOT NULL CONSTRAINT [DF_TPolicyBusinessFundTransactionAudit_TenantId] DEFAULT (0),
	[PolicyBusinessId] [int] NULL,
	[BaseType] [varchar](2) NULL,
	[EntryType] [varchar](20) NULL,
	[Category1Text] [varchar] (50) NULL,
	[Category1Code] [varchar](10) NULL,
	[Category2Text] [varchar](50) NULL,
	[Category2Code] [varchar](10) NULL,
	[PaymentFrom] [varchar](50) NULL,
	[PaymentTo] [varchar](50) NULL,
	[Frequency] [varchar](20) NULL ,
	[Reference] [varchar](50) NULL,
	[IsRestricted] [bit] NULL,
	[CreatedAt] [datetime2] NULL,
	[CreatedByUserId] [int] NULL,
	[CreatedByAppId] [varchar](100) NULL,
	[CreatedByAppName] [varchar](255) NULL,
	[UpdatedAt] [datetime2] NULL,
	[UpdatedByUserId] [int] NULL
 )
GO
ALTER TABLE [dbo].[TPolicyBusinessFundTransactionAudit] ADD CONSTRAINT [PK_TPolicyBusinessFundTransactionAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyBusinessFundTransactionAudit_StampDateTime_PolicyBusinessFundTransactionId] ON [dbo].[TPolicyBusinessFundTransactionAudit] ([StampDateTime], [PolicyBusinessFundTransactionId])
GO
CREATE CLUSTERED INDEX IX_TPolicyBusinessFundTransactionAudit_PolicyBusinessFundTransactionId ON [dbo].[TPolicyBusinessFundTransactionAudit] ([PolicyBusinessFundTransactionId])
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyBusinessFundTransactionAudit_PolicyBusinessFundId] ON TPolicyBusinessFundTransactionAudit (PolicyBusinessFundId)
go