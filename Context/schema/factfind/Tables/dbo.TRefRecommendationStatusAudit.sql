CREATE TABLE [dbo].[TRefRecommendationStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefRecommendationStatusId] [int] NULL,
[Identifier] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefRecommendationStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefRecommendationStatusAudit] ADD CONSTRAINT [PK_TRefRecommendationStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
