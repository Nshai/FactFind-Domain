CREATE TABLE [dbo].[TRefPlanAction](
	[RefPlanActionId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Identifier] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[LongDescription] nvarchar(255) null,
	[HideFromLifeCycleDesigner] [bit] NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_TRefPlanAction] PRIMARY KEY NONCLUSTERED 
(
	[RefPlanActionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TRefPlanAction] ADD  CONSTRAINT [DF_TRefPlanAction_HideFromLifecycleDesigner]  DEFAULT ((0)) FOR [HideFromLifeCycleDesigner]
GO

ALTER TABLE [dbo].[TRefPlanAction] ADD  CONSTRAINT [DF_TRefPlanAction_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO


