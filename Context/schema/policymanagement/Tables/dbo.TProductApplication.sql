CREATE TABLE [dbo].[TProductApplication]
(
[ProductApplicationId] [int] NOT NULL IDENTITY(1, 1),
[RefProductTypeId] [int] NULL,
[AppReceiptNo] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Errors] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[RiskAddressId] [int] NOT NULL,
[CorrespondanceAddressId] [int] NOT NULL,
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
[QuoteResultId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TProductApplication_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProductApplication] ADD CONSTRAINT [PK_TProductApplication] PRIMARY KEY CLUSTERED  ([ProductApplicationId])
GO
