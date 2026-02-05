CREATE TABLE [dbo].[TWorkflowStep]
(
[WorkflowStepId] [int] NOT NULL IDENTITY(1, 1),
[WorkflowId] [int] NOT NULL,
[WorkflowVersionId] [int] NULL,
[RefWorkflowStepTypeId] [int] NOT NULL,
[ActivityCategoryId] [int] NULL,
[Duration] [smallint] NULL,
[ElapsedDays] [smallint] NULL,
[RefPriorityId] [int] NULL,
[Subject] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DeletableFG] [bit] NOT NULL,
[TerminateFG] [bit] NOT NULL,
[AssignedRoleId] [int] NULL,
[QuestionText] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[FirstStepFG] [bit] NOT NULL,
[Ref] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AuthorTemplateId] [int] NULL,
[SubWorkflowId] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
