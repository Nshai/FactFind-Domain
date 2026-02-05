CREATE TABLE [dbo].[TActivityCategory]
(
[ActivityCategoryId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) NOT NULL,
[ActivityCategoryParentId] [int] NULL,
[LifeCycleTransitionId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ClientRelatedFG] [bit] NOT NULL CONSTRAINT [DF_TActivityCategory_ClientRelatedFG] DEFAULT ((0)),
[PlanRelatedFG] [bit] NOT NULL CONSTRAINT [DF_TActivityCategory_PlanRelatedFG] DEFAULT ((0)),
[FeeRelatedFG] [bit] NOT NULL CONSTRAINT [DF_TActivityCategory_FeeRelatedFG] DEFAULT ((0)),
[RetainerRelatedFG] [bit] NOT NULL CONSTRAINT [DF_TActivityCategory_RetainerRelatedFG] DEFAULT ((0)),
[OpportunityRelatedFG] [bit] NOT NULL CONSTRAINT [DF_TActivityCategory_OpportunityRelatedFG] DEFAULT ((0)),
[AdviserRelatedFg] [bit] NOT NULL CONSTRAINT [DF_TActivityCategory_AdviserRelatedFg] DEFAULT ((0)),
[ActivityEvent] [varchar] (50) NULL,
[RefSystemEventId] [int] NULL,
[TemplateTypeId] [varchar] (50) NULL,
[TemplateId] [varchar] (50) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategory_ConcurrencyId] DEFAULT ((1)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TActivityCategory_IsArchived] DEFAULT ((0)),
[GroupId] [int] NULL,
[IsPropagated] [bit] NOT NULL CONSTRAINT [DF_TActivityCategory_IsPropagated] DEFAULT ((1)),
[TaskBillingRate] [decimal] (18, 2) NULL,
[IsMandatoryOutcome] [bit] NOT NULL CONSTRAINT [DF_TActivityCategory_IsMandatoryOutcome] DEFAULT ((0)),
[EstimatedTimeHrs] [smallint] NULL,
[EstimatedTimeMins] [tinyint] NULL,
[DocumentDesignerTemplateId] [int] NULL,
[Description] [nvarchar] (max) NULL,
[RefPriorityId] [int] NULL,
[DocumentDesignerTemplateName] [varchar] (255) NULL,
[DocumentDesignerTemplateCategoryName] [varchar] (255) NULL,
[IsMandatoryTaskCheckList] [bit] NOT NULL DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TActivityCategory] ADD CONSTRAINT [PK_TActivityCategory] PRIMARY KEY CLUSTERED  ([ActivityCategoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategory_ActivityCategoryParentId] ON [dbo].[TActivityCategory] ([ActivityCategoryParentId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategory_GroupId] ON [dbo].[TActivityCategory] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategory_IndigoClientId] ON [dbo].[TActivityCategory] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategory_RefPriorityId] ON [dbo].[TActivityCategory] ([RefPriorityId])
GO
ALTER TABLE [dbo].[TActivityCategory] WITH CHECK ADD CONSTRAINT [FK_TActivityCategoryParent_TActivityCategory] FOREIGN KEY ([ActivityCategoryParentId]) REFERENCES [dbo].[TActivityCategoryParent] ([ActivityCategoryParentId])
GO
ALTER TABLE [dbo].[TActivityCategory] WITH CHECK ADD CONSTRAINT [FK_TRefPriority_TActivityCategory] FOREIGN KEY ([RefPriorityId]) REFERENCES [dbo].[TRefPriority] ([RefPriorityId])
GO