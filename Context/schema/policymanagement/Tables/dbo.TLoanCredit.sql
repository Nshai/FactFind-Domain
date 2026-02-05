CREATE TABLE [dbo].[TLoanCredit]
(
[LoanCreditId] int NOT NULL IDENTITY(1,1),
[IndigoClientId] int NOT NULL,
[PolicyBusinessId] int NOT NULL,
[OriginalLoanAmount] money NULL,
[RefLoanCreditTypeId] int NULL,
[RefRateTypeId] int NULL,
[CreditLimit] money NULL,
[LoanTermInMonths] int NULL, 
[RefProtectionTypeId] int NULL,
[RedemptionTerms] varchar(255) NULL,
[IsToBeConsolidated] bit NOT NULL CONSTRAINT [DF_TLoanCredit_IsToBeConsolidated] DEFAULT((0)),
[IsLiabilityToBeRepaid] bit NULL,
[LiabilityRepaymentDescription] varchar(500) NULL
)
GO
ALTER TABLE [dbo].[TLoanCredit] 
ADD CONSTRAINT [PK_TLoanCredit] 
PRIMARY KEY NONCLUSTERED  ([LoanCreditId])
GO

ALTER TABLE [dbo].[TLoanCredit] 
ADD CONSTRAINT [FK_TLoanCredit_PolicyBusinessId] 
FOREIGN KEY ([PolicyBusinessId]) 
REFERENCES [dbo].TPolicyBusiness ([PolicyBusinessId])
GO

ALTER TABLE [dbo].[TLoanCredit] 
ADD CONSTRAINT [FK_TLoanCredit_RefLoanCreditTypeId] 
FOREIGN KEY ([RefLoanCreditTypeId]) 
REFERENCES [dbo].TRefLoanCreditType ([RefLoanCreditTypeId])
GO

ALTER TABLE [dbo].[TLoanCredit] 
ADD CONSTRAINT [FK_TLoanCredit_RefRateTypeId] 
FOREIGN KEY ([RefRateTypeId]) 
REFERENCES [dbo].TRefRateType ([RefRateTypeId])
GO

ALTER TABLE [dbo].[TLoanCredit] 
ADD CONSTRAINT [FK_TLoanCredit_RefProtectionTypeId] 
FOREIGN KEY ([RefProtectionTypeId]) 
REFERENCES [dbo].TRefProtectionType ([RefProtectionTypeId])
GO