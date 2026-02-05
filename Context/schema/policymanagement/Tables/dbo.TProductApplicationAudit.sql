CREATE TABLE [dbo].[TProductApplicationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProductApplicationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ProductApplicationId] [int] NULL,
[AppReceiptNo] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Errors] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NULL,
[RefProductTypeId] [int] NULL,
[RiskAddressId] [int] NULL,
[CorrespondanceAddressId] [int] NULL,
[BankAccountId] [int] NULL,
[DirectDebitDate] [int] NULL,
[Applicant1Id] [int] NULL,
[Applicant2Id] [int] NULL,
[AdditionalInfo] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[YourRef] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MortgageLender] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MortgageStartDate] [datetime] NULL,
[PolicyStartDate] [datetime] NULL,
[TypeOfBorrowing] [int] NULL,
[SharedOwnership] [int] NULL,
[AdvancedBorrowing] [int] NULL,
[ProfessionalContactId] [int] NULL,
[IsFaxAcceptToSolicitor] [bit] NULL,
[IsFaxRiskNotificationToSolicitor] [bit] NULL,
[MortgageCompletionDate] [datetime] NULL,
[QuoteResultId] [int] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TProductApplicationAudit_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProductApplicationAudit] ADD CONSTRAINT [PK_TProductApplicationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
