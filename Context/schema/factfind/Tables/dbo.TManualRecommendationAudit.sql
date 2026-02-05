CREATE TABLE [dbo].[TManualRecommendationAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[ManualRecommendationId] [int] NOT NULL,
	[IndigoClientId] [int] NOT NULL,
	[FinancialPlanningSessionId] [int] NOT NULL,
	[RefRecommendationSolutionStatusId] [int] NOT NULL,
	[ModificationDate] [datetime] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_TManualRecommendationAudit_CreationDate] DEFAULT GETDATE(),
	[RecommendationName] [nvarchar](100) NULL
 CONSTRAINT [PK_TManualRecommendationAudit] PRIMARY KEY NONCLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TManualRecommendationAudit] ADD  CONSTRAINT [DF_TManualRecommendationAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]
GO


