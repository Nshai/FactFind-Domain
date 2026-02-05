CREATE TABLE [dbo].[TRecommendationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Recommendation] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RecommendationStatus] [tinyint] NULL,
[StatusDate] [datetime] NULL,
[IsJoint] [bit] NOT NULL,
[JointCRMContactId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RecommendationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRecommend_StampDateTime_1__61] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRecommendationAudit] ADD CONSTRAINT [PK_TRecommendationAudit_2__61] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRecommendationAudit_RecommendationId_ConcurrencyId] ON [dbo].[TRecommendationAudit] ([RecommendationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
