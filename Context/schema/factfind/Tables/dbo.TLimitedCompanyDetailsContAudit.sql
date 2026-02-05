CREATE TABLE [dbo].[TLimitedCompanyDetailsContAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IncorporationRegistrationNumber] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ProvideForLossYesNo] [bit] NULL,
[ProductProvider] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DateCoverEffected] [datetime] NULL,
[RenewablePremiums] [datetime] NULL,
[SumAssured] [money] NULL,
[Term] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AnnualCost] [money] NULL,
[DisablementCoverYesNo] [bit] NULL,
[DirectorsProtectedYesNo] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[LimitedCompanyDetailsContId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TLimitedC__Concu__3469B275] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLimitedCompanyDetailsContAudit] ADD CONSTRAINT [PK_TLimitedCompanyDetailsContAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
