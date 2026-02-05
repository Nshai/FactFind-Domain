CREATE TABLE [dbo].[TQuoteItemRecommendationStatusAudit](
			[AuditId] [int] IDENTITY(1,1) NOT NULL,
			[QuoteItemRecommendationStatusId] [int] NULL,
			[QuoteItemId] [int] NULL,
			[QuoteResultId] [int] NULL,
			[RefRecommendationStatusId] [int] NULL,
			[StatusDate] [datetime] NULL,
			[ConcurrencyId] [int] NULL,
			[RefSolutionStatusId] [int] NULL CONSTRAINT [DF_TQuoteItemRecommendationStatusAudit_RefSolutionStatusId] DEFAULT ((1)),
			[SolutionStatusDate] [datetime] NULL,
			[StampAction] [char](1) NOT NULL,
			[StampDateTime] [datetime] NULL,
			[FinancialPlanningSessionId] [int] NULL,
			[StampUser] [varchar](255) NULL,
			[RejectReasonId]   	[int] NULL,
			[RejectReasonNote]	[ntext]	NULL,
			[DeferReasonId]   	[int] NULL,
			[DeferReasonNote]	[ntext]	NULL,
			[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_TQuoteItemRecommendationStatusAudit_CreationDate] DEFAULT GETDATE(),
			[PolicyBusinessId] [int] NULL,
            [RecommendationName] [nvarchar](100) NULL			
		 CONSTRAINT [PK_TQuoteItemRecommendationStatusAudit] PRIMARY KEY CLUSTERED 
		(
			[AuditId] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TQuoteItemRecommendationStatusAudit] ADD  CONSTRAINT [DF_TQuoteItemRecommendationStatusAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]		
GO