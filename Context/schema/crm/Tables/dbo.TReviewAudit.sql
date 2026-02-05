CREATE TABLE [dbo].[TReviewAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Version] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL,
[Status] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedOn] [datetime] NOT NULL,
[CrmContactId1] [int] NOT NULL,
[CrmContactId2] [int] NULL,
[ReviewDefinitionId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[ReviewId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TReviewAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TReviewAudit] ADD CONSTRAINT [PK_TReviewAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TReviewAudit_ReviewId_ConcurrencyId] ON [dbo].[TReviewAudit] ([ReviewId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
