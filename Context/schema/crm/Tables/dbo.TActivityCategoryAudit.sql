CREATE TABLE [dbo].[TActivityCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (50) NOT NULL,
[ActivityCategoryParentId] [int] NULL,
[LifeCycleTransitionId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ClientRelatedFG] [bit] NOT NULL CONSTRAINT [DF_TActivityCategoryAudit_ClientRelatedFG] DEFAULT ((0)),
[PlanRelatedFG] [bit] NOT NULL CONSTRAINT [DF_TActivityCategoryAudit_PlanRelatedFG] DEFAULT ((0)),
[FeeRelatedFG] [bit] NOT NULL CONSTRAINT [DF_TActivityCategoryAudit_FeeRelatedFG] DEFAULT ((0)),
[RetainerRelatedFG] [bit] NOT NULL CONSTRAINT [DF_TActivityCategoryAudit_RetainerRelatedFG] DEFAULT ((0)),
[OpportunityRelatedFG] [bit] NOT NULL CONSTRAINT [DF_TActivityCategoryAudit_OpportunityRelatedFG] DEFAULT ((0)),
[AdviserRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TActivityCategoryAudit_AdviserRelatedFg] DEFAULT ((0)),
[ActivityEvent] [varchar] (50) NULL,
[RefSystemEventId] [int] NULL,
[TemplateTypeId] [varchar] (50) NULL,
[TemplateId] [varchar] (50) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[ActivityCategoryId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TActivityCategoryAudit_IsArchived] DEFAULT ((0)),
[GroupId] [int] NULL,
[IsPropagated] [bit] NULL,
[TaskBillingRate] [decimal] (18, 2) NULL,
[EstimatedTimeHrs] [smallint] NULL,
[EstimatedTimeMins] [tinyint] NULL,
[DocumentDesignerTemplateId] [int] NULL,
[Description] [nvarchar] (max) NULL,
[RefPriorityId] [int] NULL,
[IsMandatoryTaskCheckList] [bit] NOT NULL DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TActivityCategoryAudit] ADD CONSTRAINT [PK_TActivityCategoryAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TActivityCategoryAudit_StampDateTime] ON [dbo].[TActivityCategoryAudit] (StampDateTime) INCLUDE (ActivityCategoryId)
