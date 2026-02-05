CREATE TABLE [dbo].[TEstateneeds]
(
[EstateneedsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[LeaveAssetsYN] [bit] NULL,
[LeaveAssetsDesc] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[EstateProvideIncomeYN] [bit] NULL,
[EstateProvideIncomeDesc] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[SufficientInsuranceYN] [bit] NULL,
[InsufficientInsuranceDesc] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstatene__Concu__21C0F255] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEstateneeds_CRMContactId] ON [dbo].[TEstateneeds] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
