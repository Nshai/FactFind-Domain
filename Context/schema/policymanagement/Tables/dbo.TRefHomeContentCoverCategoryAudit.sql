CREATE TABLE [dbo].[TRefHomeContentCoverCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (256) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL,
[ConcurrencyId] [int] NULL,
[RefHomeContentCoverCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefHomeContentCoverCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefHomeContentCoverCategoryAudit] ADD CONSTRAINT [PK_TRefHomeContentCoverCategoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
