CREATE TABLE [dbo].[TRefPlanActionAudit](
	[AuditId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Identifier] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
    [LongDescription] nvarchar(255) null,	
	[HideFromLifeCycleDesigner] [bit] NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[RefPlanActionId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
 CONSTRAINT [PK_TRefPlanActionAudit] PRIMARY KEY NONCLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TRefPlanActionAudit] ADD  CONSTRAINT [DF_TRefPlanActionAudit_HideFromLifeCycleDesigner]  DEFAULT ((0)) FOR [HideFromLifeCycleDesigner]
GO

ALTER TABLE [dbo].[TRefPlanActionAudit] ADD  CONSTRAINT [DF_TRefPlanActionAudit_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO

ALTER TABLE [dbo].[TRefPlanActionAudit] ADD  CONSTRAINT [DF_TRefPlanActionAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]
GO


