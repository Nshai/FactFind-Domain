CREATE TABLE [dbo].[TQuoteApplicant]
(
[QuoteApplicantId] [int] NOT NULL IDENTITY(1, 1),
[RefEmploymentStatusId] [int] NOT NULL,
[EmployerName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[EmploymentMonths] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[JobRole] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[JobIndustry] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[EmployerAddressId] [int] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TQuoteApplicant_ConcurrencyId] DEFAULT ((1)),
[PartyId] [int] NOT NULL,
[ProductApplicationId] [int] NULL,
[PropertyDetailId] [int] NULL
)
GO
ALTER TABLE [dbo].[TQuoteApplicant] ADD CONSTRAINT [PK_TQuoteApplicant] PRIMARY KEY CLUSTERED  ([QuoteApplicantId])
GO
