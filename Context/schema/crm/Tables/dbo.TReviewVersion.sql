CREATE TABLE [dbo].[TReviewVersion]
(
[ReviewVersionId] [int] NOT NULL IDENTITY(1, 1),
[Document] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Version] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TReviewVersion_Version] DEFAULT ('draft'),
[Status] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TReviewVersion_Status] DEFAULT ('1.0'),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_TReviewVersion_CreatedOn] DEFAULT (getdate()),
[ReviewId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TReviewVersion_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TReviewVersion] ADD CONSTRAINT [PK_TReviewVersion_ReviewVersionId] PRIMARY KEY CLUSTERED  ([ReviewVersionId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TReviewVersion] ADD CONSTRAINT [FK_TReviewVersion_ReviewId_ReviewId] FOREIGN KEY ([ReviewId]) REFERENCES [dbo].[TReview] ([ReviewId])
GO
