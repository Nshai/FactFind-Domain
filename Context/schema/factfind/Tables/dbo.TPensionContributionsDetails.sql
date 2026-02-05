CREATE TABLE [dbo].[TPensionContributionsDetails]
(
[PensionContributionsDetailsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[AnnualContributionCompany] [money] NULL,
[NormalRetirementAge] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[NumberOfEmployeesInScheme] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LumpSumOnDeathInService] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[WidowPensionOnDeathInService] [money] NULL,
[WidowPensionOnDeathAfterRetirement] [money] NULL,
[HowIsTheSchemeCalculated2] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DetailsOfInHouseAVCScheme] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[BenefitsPayableEmployeeDisabled] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AdditionalBenefitsForDirectors] [bit] NULL,
[AdditionalBenefitsForDirectorsDetails] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[DirectorsRetiringShortly] [bit] NULL,
[DirectorsRetiringShortlyDetails] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[NewDirectors] [bit] NULL,
[NewDirectorsDetails] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[InterestedInGPP] [bit] NULL,
[InterestedInDirectOffer] [bit] NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPensionContributionsDetails__ConcurrencyId] DEFAULT ((1)),
[AccrualRate] [smallint] NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPensionContributionsDetails_CRMContactId] ON [dbo].[TPensionContributionsDetails] ([CRMContactId])
GO
