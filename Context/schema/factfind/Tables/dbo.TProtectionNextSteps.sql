CREATE TABLE [dbo].[TProtectionNextSteps]
(
[ProtectionNextStepsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NextSteps] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProtecti__Concu__386F4D83] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TProtectionNextSteps_CRMContactId] ON [dbo].[TProtectionNextSteps] ([CRMContactId])
GO
