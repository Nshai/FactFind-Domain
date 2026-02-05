CREATE TABLE [dbo].[TInsurancePlansExt]
(
[InsurancePlansExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[AmountofCover] [decimal] (10, 2) NULL,
[AccidentalDamageIncluded] [bit] NULL,
[AmountofExcess] [decimal] (10, 2) NULL,
[IncludeAccidentalCover] [bit] NULL,
[IncludePersonalPossessions] [bit] NULL,
[AwayfromHome] [bit] NULL,
[AssetsId] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInsurancePlansExt_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TInsurancePlansExt] ADD CONSTRAINT [PK_TInsurancePlansExt] PRIMARY KEY NONCLUSTERED  ([InsurancePlansExtId]) WITH (FILLFACTOR=80)
GO
