CREATE TABLE [dbo].[TEmployeeBenefitCont]
(
[EmployeeBenefitContId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ConcernsYesNo] [bit] NULL,
[Concerns] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEmployeeBenefitCont__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEmployeeBenefitCont_CRMContactId] ON [dbo].[TEmployeeBenefitCont] ([CRMContactId])
GO
