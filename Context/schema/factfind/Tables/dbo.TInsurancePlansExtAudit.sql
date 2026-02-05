CREATE TABLE [dbo].[TInsurancePlansExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[AmountofCover] [decimal] (10, 2) NULL,
[AccidentalDamageIncluded] [bit] NULL,
[AmountofExcess] [decimal] (10, 2) NULL,
[IncludeAccidentalCover] [bit] NULL,
[IncludePersonalPossessions] [bit] NULL,
[AwayfromHome] [bit] NULL,
[AssetsId] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInsurancePlansExtAudit_ConcurrencyId] DEFAULT ((1)),
[InsurancePlansExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInsurancePlansExtAudit] ADD CONSTRAINT [PK_TInsurancePlansExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
