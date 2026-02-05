CREATE TABLE [dbo].[TSavingsFFExt]
(
[SavingsFFExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExistingDeposits] [bit] NULL,
[NonDisclosureCash] [bit] NULL,
[OtherInvestments] [bit] NULL,
[GoalsAndNeeds] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NextSteps] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NonDisclosureOther] [bit] NULL,
[Client1Total] [money] NULL,
[Client2Total] [money] NULL,
[JointTotal] [money] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_TSavingsFFExt_CRMContactId] ON [dbo].[TSavingsFFExt] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
