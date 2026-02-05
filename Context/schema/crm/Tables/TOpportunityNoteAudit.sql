CREATE TABLE [dbo].[TOpportunityNoteAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[OpportunityNoteId] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[OpportunityId] [int] NOT NULL,
	[Text] [varchar](max) COLLATE Latin1_General_CI_AS NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[IsSystem] [bit] NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[StampAction] [char](1) NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
 CONSTRAINT [PK_TOpportunityNoteAudit] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TOpportunityNoteAudit] ADD  CONSTRAINT [DF_TOpportunityNoteAudit_IsSystem]  DEFAULT ((0)) FOR [IsSystem]

ALTER TABLE [dbo].[TOpportunityNoteAudit] ADD  CONSTRAINT [DF_TOpportunityNoteAudit_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]

CREATE NONCLUSTERED INDEX [IX_TOpportunityNoteAudit_TenantId_OpportunityId] ON [dbo].[TOpportunityNoteAudit] ([TenantId],[OpportunityId])

CREATE NONCLUSTERED INDEX [IX_TOpportunityNoteAudit_TenantId_OpportunityNoteId] ON [dbo].[TOpportunityNoteAudit] ([TenantId],[OpportunityNoteId])
GO