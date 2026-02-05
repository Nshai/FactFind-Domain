CREATE TABLE [dbo].[TManualRecommendation](
	[ManualRecommendationId] [int] IDENTITY(1,1) NOT NULL,
	[IndigoClientId] [int] NOT NULL,
	[FinancialPlanningSessionId] [int] NOT NULL,
	[RefRecommendationSolutionStatusId] [int] NOT NULL,
	[ModificationDate] [datetime] NOT NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_TManualRecommendation_CreationDate] DEFAULT GETDATE(),
	[RecommendationName] [nvarchar](100) NULL
 CONSTRAINT [PK_TManualRecommendation] PRIMARY KEY NONCLUSTERED 
(
	[ManualRecommendationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TManualRecommendation] ADD  CONSTRAINT [DF_TManualRecommendation_ModificationDate]  DEFAULT (getdate()) FOR [ModificationDate]
GO


 