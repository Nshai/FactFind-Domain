CREATE TABLE [dbo].[TRetirePlanningExisting]
(
[RetirePlanningExistingId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[RetirementPlanningObjectives] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CurrentPensionArrangements] [bit] NULL,
[PlanTypes] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetirePl__Concu__5728DECD] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TRetirePlanningExisting_CRMContactId] ON [dbo].[TRetirePlanningExisting] ([CRMContactId])
GO
