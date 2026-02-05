CREATE TABLE [dbo].[TNonOccupationalScheme]
(
[NonOccupationalSchemeId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[TypeOfContract] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NameOfCompany] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[ReviewDate] [datetime] NULL,
[PolicyHolder] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[EmployeePremium] [money] NULL,
[EmployerPremium] [money] NULL,
[DeathSumAssured] [money] NULL,
[InTrust] [bit] NULL,
[NameOfBeneficiary] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[PlanContractedOutOfS2P] [bit] NULL,
[NameOfProductProvider] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TNonOccup__Concu__6482D9EB] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TNonOccupationalScheme_CRMContactId] ON [dbo].[TNonOccupationalScheme] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
