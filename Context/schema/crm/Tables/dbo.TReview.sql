CREATE TABLE [dbo].[TReview]
(
[ReviewId] [int] NOT NULL IDENTITY(1, 1),
[Version] [varchar] (16)  NOT NULL CONSTRAINT [DF_TReview_Version] DEFAULT ((1.0)),
[Status] [varchar] (16)  NOT NULL CONSTRAINT [DF_TReview_Status] DEFAULT ('draft'),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_TReview_CreatedOn] DEFAULT (getdate()),
[CrmContactId1] [int] NOT NULL,
[CrmContactId2] [int] NULL,
[ReviewDefinitionId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TReview_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TReview] ADD CONSTRAINT [PK_TReview_ReviewId] PRIMARY KEY CLUSTERED  ([ReviewId])
GO
ALTER TABLE [dbo].[TReview] WITH CHECK ADD CONSTRAINT [FK_TReview_CrmContactId1_CrmContactId] FOREIGN KEY ([CrmContactId1]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TReview] WITH CHECK ADD CONSTRAINT [FK_TReview_CrmContactId2_CrmContactId] FOREIGN KEY ([CrmContactId2]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TReview] ADD CONSTRAINT [FK_TReview_ReviewDefinitionId_ReviewDefinitionId] FOREIGN KEY ([ReviewDefinitionId]) REFERENCES [dbo].[TReviewDefinition] ([ReviewDefinitionId])
GO
