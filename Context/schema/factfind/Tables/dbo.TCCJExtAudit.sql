CREATE TABLE [dbo].[TCCJExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CCJExtId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[CCJDefaultFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCCJExtAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCCJExtAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCCJExtAudit] ADD CONSTRAINT [PK_TCCJExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCCJExtAudit_CCJExtId_ConcurrencyId] ON [dbo].[TCCJExtAudit] ([CCJExtId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
