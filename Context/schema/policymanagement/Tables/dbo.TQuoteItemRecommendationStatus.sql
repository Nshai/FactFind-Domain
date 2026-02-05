CREATE TABLE [dbo].[TQuoteItemRecommendationStatus](
			[QuoteItemRecommendationStatusId] [int] IDENTITY(1,1) NOT NULL,
			[QuoteItemId] [int] NULL,
			[QuoteResultId] [int] NULL,
			[RefRecommendationStatusId] [int] NULL,
			[StatusDate] [datetime] NULL,
			[ConcurrencyId] [int] NULL,
			[RefSolutionStatusId] [int] NULL CONSTRAINT [DF_TQuoteItemRecommendationStatus_RefSolutionStatusId] DEFAULT ((1)),
			[FinancialPlanningSessionId] [int] NULL,
			[SolutionStatusDate] [datetime] NULL,
			[RejectReasonId]   	[int] NULL,
			[RejectReasonNote]	[ntext]	NULL,
			[DeferReasonId]   	[int] NULL,
			[DeferReasonNote]	[ntext]	NULL,
			[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_TQuoteItemRecommendationStatus_CreationDate] DEFAULT GETDATE(),
			[PolicyBusinessId] [int] NULL,
			[RecommendationName] [nvarchar](100) NULL
		 CONSTRAINT [PK_TQuoteItemRecommendationStatus] PRIMARY KEY CLUSTERED 
		(
			[QuoteItemRecommendationStatusId] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]
		
GO