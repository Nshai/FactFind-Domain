CREATE TABLE [dbo].[TRecommendation]
(
[RecommendationId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Recommendation] [varchar] (255)  NULL,
[RecommendationStatus] [tinyint] NULL,
[StatusDate] [datetime] NULL,
[IsJoint] [bit] NOT NULL,
[JointCRMContactId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRecommendation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRecommendation] ADD CONSTRAINT [PK_TRecommendation] PRIMARY KEY NONCLUSTERED  ([RecommendationId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRecommendation_CRMContactId] ON [dbo].[TRecommendation] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRecommendation_JointCRMContactId] ON [dbo].[TRecommendation] ([JointCRMContactId])
GO
ALTER TABLE [dbo].[TRecommendation] WITH CHECK ADD CONSTRAINT [FK_TRecommendation_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TRecommendation] WITH CHECK ADD CONSTRAINT [FK_TRecommendation_JointCRMContactId_CRMContactId] FOREIGN KEY ([JointCRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
