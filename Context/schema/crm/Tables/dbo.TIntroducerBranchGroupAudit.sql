CREATE TABLE [dbo].[TIntroducerBranchGroupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GroupId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TIntroducerBranchGroupAudit_ConcurrencyId] DEFAULT ((1)),
[IntroducerBranchGroupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIntroducerBranchGroupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIntroducerBranchGroupAudit] ADD CONSTRAINT [PK_TIntroducerBranchGroupAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
