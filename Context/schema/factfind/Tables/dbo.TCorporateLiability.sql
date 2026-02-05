CREATE TABLE [dbo].[TCorporateLiability]
(
[CorporateLiabilityId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Nature] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[OutstandingAmount] [money] NULL,
[RepaymentMethod] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RepaymentDate] [datetime] NULL,
[LiabilityName] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[LiabilityType] [varchar] (256) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCorporateLiability__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateLiability_CRMContactId] ON [dbo].[TCorporateLiability] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
