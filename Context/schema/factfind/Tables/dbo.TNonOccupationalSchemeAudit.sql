CREATE TABLE [dbo].[TNonOccupationalSchemeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[CRMContactId] [int] NOT NULL,
[NonOccupationalSchemeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TNonOccup__Concu__383A4359] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNonOccupationalSchemeAudit] ADD CONSTRAINT [PK_TNonOccupationalSchemeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
