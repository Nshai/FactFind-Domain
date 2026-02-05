CREATE TABLE [dbo].[TCRMContactKeyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EntityId] [int] NULL,
[CreatorId] [int] NULL,
[UserId] [int] NULL,
[RoleId] [int] NULL,
[RightMask] [int] NOT NULL CONSTRAINT [DF_TCRMContactKeyAudit_RightMask] DEFAULT ((0)),
[AdvancedMask] [int] NOT NULL CONSTRAINT [DF_TCRMContactKeyAudit_AdvancedMask] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCRMContactKeyAudit_ConcurrencyId] DEFAULT ((1)),
[CRMContactKeyId] [bigint] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCRMContactKeyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCRMContactKeyAudit] ADD CONSTRAINT [PK_TCRMContactKeyAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
