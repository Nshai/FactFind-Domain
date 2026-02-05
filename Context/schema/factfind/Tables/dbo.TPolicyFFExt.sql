CREATE TABLE [dbo].[TPolicyFFExt]
(
[PolicyFFExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExistingProtection] [bit] NULL,
[NonDisclosure] [bit] NULL,
[GoalsAndNeeds] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NextSteps] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ExistingDeathInServiceBenefits] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyFFExt_CRMContactId] ON [dbo].[TPolicyFFExt] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
