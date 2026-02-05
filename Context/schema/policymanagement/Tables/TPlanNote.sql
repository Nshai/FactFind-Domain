CREATE TABLE [dbo].[TPlanNote](
	[PlanNoteId] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK_TPlanNote] PRIMARY KEY CLUSTERED 
(
	[PlanNoteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TPlanNote] ADD  CONSTRAINT [DF_TPlanNote_IsSystem]  DEFAULT ((0)) FOR [IsSystem]

ALTER TABLE [dbo].[TPlanNote] ADD  CONSTRAINT [DF_TPlanNote_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
