CREATE TABLE [dbo].[TReviewCommentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Comment] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[UpdatedOn] [datetime] NOT NULL,
[SectionId] [int] NOT NULL,
[ReviewId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ReviewCommentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TReviewCommentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TReviewCommentAudit] ADD CONSTRAINT [PK_TReviewCommentAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TReviewCommentAudit_ReviewCommentId_ConcurrencyId] ON [dbo].[TReviewCommentAudit] ([ReviewCommentId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
