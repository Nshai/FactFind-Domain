CREATE TABLE [dbo].[TIntroducerBranchAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerId] [int] NOT NULL,
[BranchName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[IntroducerBranchId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIntroducerBranchAudit] ADD CONSTRAINT [PK_TIntroducerBranchAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TIntroducerBranchAudit_IntroducerBranchId_StampDateTime] ON [dbo].[TIntroducerBranchAudit] ([IntroducerBranchId], [StampDateTime]) WITH (FILLFACTOR=90)
GO
