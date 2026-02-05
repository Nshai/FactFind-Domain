CREATE TABLE [dbo].[TPensionContributionsDetailsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[CRMContactId] [int] NOT NULL,
[PensionContributionsDetailsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPensionContributionsDetailsAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AccrualRate] [smallint] NULL
)
GO
ALTER TABLE [dbo].[TPensionContributionsDetailsAudit] ADD CONSTRAINT [PK_TPensionContributionsDetailsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
