CREATE TABLE [dbo].[TReviewComment]
(
[ReviewCommentId] [int] NOT NULL IDENTITY(1, 1),
[Comment] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_TReviewComment_UpdatedOn] DEFAULT (getdate()),
[SectionId] [int] NOT NULL,
[ReviewId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TReviewComment_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TReviewComment] ADD CONSTRAINT [PK_TReviewComment_ReviewCommentId] PRIMARY KEY CLUSTERED  ([ReviewCommentId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TReviewComment] ADD CONSTRAINT [FK_TReviewComment_ReviewId_ReviewId] FOREIGN KEY ([ReviewId]) REFERENCES [dbo].[TReview] ([ReviewId])
GO
ALTER TABLE [dbo].[TReviewComment] ADD CONSTRAINT [FK_TReviewComment_SectionId_SectionId] FOREIGN KEY ([SectionId]) REFERENCES [dbo].[TSection] ([SectionId])
GO
