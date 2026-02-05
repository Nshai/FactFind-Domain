CREATE TABLE [dbo].[TEmailSetupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[DisplayName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AutomaticBccFg] [bit] NOT NULL CONSTRAINT [DF_TEmailSetupAudit_AutomaticBccFg] DEFAULT ((1)),
[Signatures] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailSetupAudit_ConcurrencyId] DEFAULT ((1)),
[EmailSetupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEmailSetupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEmailSetupAudit] ADD CONSTRAINT [PK_TEmailSetupAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
