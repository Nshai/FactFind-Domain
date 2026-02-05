CREATE TABLE [dbo].[TPractitionerKeyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EntityId] [int] NULL,
[CreatorId] [int] NULL,
[UserId] [int] NULL,
[RoleId] [int] NULL,
[RightMask] [int] NOT NULL CONSTRAINT [DF_TPractitionerKeyAudit_RightMask] DEFAULT ((0)),
[AdvancedMask] [int] NOT NULL CONSTRAINT [DF_TPractitionerKeyAudit_AdvancedMask] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPractitionerKeyAudit_ConcurrencyId] DEFAULT ((1)),
[PractitionerKeyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPractitionerKeyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPractitionerKeyAudit] ADD CONSTRAINT [PK_TPractitionerKeyAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
