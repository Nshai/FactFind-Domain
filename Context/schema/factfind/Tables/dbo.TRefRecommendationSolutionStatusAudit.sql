CREATE TABLE [dbo].[TRefRecommendationSolutionStatusAudit]
(
[RefRecommendationSolutionStatusAuditId] [int] NOT NULL IDENTITY(1, 1),
[RefRecommendationSolutionStatusId] [int] NULL,
[Status] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefRecommendationSolutionStatusAudit] ADD CONSTRAINT [PK_TRefRecommendationSolutionStatusAudit] PRIMARY KEY CLUSTERED  ([RefRecommendationSolutionStatusAuditId])
GO
