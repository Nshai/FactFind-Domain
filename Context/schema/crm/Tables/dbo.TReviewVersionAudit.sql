CREATE TABLE [dbo].[TReviewVersionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Document] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Version] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL,
[Status] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedOn] [datetime] NOT NULL,
[ReviewId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[ReviewVersionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TReviewVersionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TReviewVersionAudit] ADD CONSTRAINT [PK_TReviewVersionAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TReviewVersionAudit_ReviewDefinitionId_ConcurrencyId] ON [dbo].[TReviewVersionAudit] ([ReviewVersionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
