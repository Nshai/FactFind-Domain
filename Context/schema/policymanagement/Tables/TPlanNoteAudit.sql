CREATE TABLE [dbo].[TPlanNoteAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[PlanNoteId] [int] NOT NULL,
	[PlanId] [int] NOT NULL,
	[Text] [varchar](max) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[IsSystem] [bit] NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[MigrationRef] [varchar](255) NULL,
	[PlanMigrationRef] [varchar](255) NULL,
	[StampAction] [char](1) NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
 CONSTRAINT [PK_TPlanNoteAudit] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TPlanNoteAudit] ADD  CONSTRAINT [DF_TPlanNoteAudit_IsSystem]  DEFAULT ((0)) FOR [IsSystem]

ALTER TABLE [dbo].[TPlanNoteAudit] ADD  CONSTRAINT [DF_TPlanNoteAudit_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]