CREATE TABLE [dbo].[TCorporateProtectionPlanExt]
(
[CorporateProtectionPlanExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[AssignedInTrustDetails] [varchar] (2304) COLLATE Latin1_General_CI_AS NULL,
[IntendToCancel] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCorporateProtectionPlanExt_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateProtectionPlanExt_CRMContactId] ON [dbo].[TCorporateProtectionPlanExt] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
