CREATE TABLE [dbo].[TAdviceCaseObjectiveAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[ObjectiveId] [int] NOT NULL,
[AdviceCaseObjectiveId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseObjectiveAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseObjectiveAudit] ADD CONSTRAINT [PK_TAdviceCaseObjectiveAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
