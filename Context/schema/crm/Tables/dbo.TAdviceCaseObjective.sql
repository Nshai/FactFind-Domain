CREATE TABLE [dbo].[TAdviceCaseObjective]
(
[AdviceCaseObjectiveId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[ObjectiveId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseObjective] ADD CONSTRAINT [PK_TAdviceCaseObjective] PRIMARY KEY CLUSTERED  ([AdviceCaseObjectiveId])
GO
CREATE NONCLUSTERED INDEX IX_TAdviceCaseObjective_ObjectiveId ON [dbo].[TAdviceCaseObjective] ([ObjectiveId])
GO
CREATE NONCLUSTERED INDEX IX_TAdviceCaseObjective_AdviceCaseId ON [dbo].[TAdviceCaseObjective] ([AdviceCaseId])
GO