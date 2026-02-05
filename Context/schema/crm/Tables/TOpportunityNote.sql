CREATE TABLE [dbo].[TOpportunityNote](
	[OpportunityNoteId] [int] IDENTITY(1,1) NOT NULL,
	[TenantId] [int] NOT NULL,
	[OpportunityId] [int] NOT NULL,
	[Text] [varchar](max) COLLATE Latin1_General_CI_AS NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[IsSystem] [bit] NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_TOpportunityNote] PRIMARY KEY CLUSTERED 
(
	[OpportunityNoteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TOpportunityNote] ADD  CONSTRAINT [DF_TOpportunityNote_IsSystem]  DEFAULT ((0)) FOR [IsSystem]

ALTER TABLE [dbo].[TOpportunityNote] ADD  CONSTRAINT [DF_TOpportunityNote_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]

CREATE NONCLUSTERED INDEX [IX_TOpportunityNote_TenantId_OpportunityId] ON [dbo].[TOpportunityNote] ([TenantId],[OpportunityId])
GO