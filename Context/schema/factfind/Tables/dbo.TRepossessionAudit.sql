CREATE TABLE [dbo].[TRepossessionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[repDate] [datetime] NULL,
[repLenderName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[repDebt] [bit] NULL,
[repApp1] [bit] NULL,
[repApp2] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRepossessionAudit_ConcurrencyId] DEFAULT ((1)),
[RepossessionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRepossessionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRepossessionAudit] ADD CONSTRAINT [PK_TRepossessionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRepossessionAudit_RepossessionId_ConcurrencyId] ON [dbo].[TRepossessionAudit] ([RepossessionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
