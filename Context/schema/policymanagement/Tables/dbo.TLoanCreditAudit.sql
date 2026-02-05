CREATE TABLE [dbo].[TLoanCreditAudit]
(
[AuditId] int NOT NULL IDENTITY(1,1),
[LoanCreditId] int NOT NULL,
[IndigoClientId] int NOT NULL,
[PolicyBusinessId] int NOT NULL,
[OriginalLoanAmount] money NULL,
[RefLoanCreditTypeId] int NULL,
[RefRateTypeId] int NULL,
[CreditLimit] money NULL,
[LoanTermInMonths] int NULL, 
[RefProtectionTypeId] int NULL,
[RedemptionTerms] varchar(255) NULL,
[IsToBeConsolidated] bit NOT NULL CONSTRAINT [DF_TLoanCreditAudit_IsToBeConsolidated] DEFAULT((0)),
[IsLiabilityToBeRepaid] bit NULL,
[LiabilityRepaymentDescription] varchar(500) NULL,
[StampAction] [char](1) NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar](255) NULL,
)
GO
ALTER TABLE [dbo].[TLoanCreditAudit] 
ADD CONSTRAINT [PK_TLoanCreditAudit] 
PRIMARY KEY NONCLUSTERED  ([AuditId])
GO

ALTER TABLE [dbo].[TLoanCreditAudit] 
ADD CONSTRAINT [DK_TLoanCreditAudit_StampDateTime] 
DEFAULT (getdate()) FOR [StampDateTime]
GO