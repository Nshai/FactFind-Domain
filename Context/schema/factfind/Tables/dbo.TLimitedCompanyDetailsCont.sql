CREATE TABLE [dbo].[TLimitedCompanyDetailsCont]
(
[LimitedCompanyDetailsContId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TLimitedC__Concu__60B24907] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TLimitedCompanyDetailsCont_CRMContactId] ON [dbo].[TLimitedCompanyDetailsCont] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
