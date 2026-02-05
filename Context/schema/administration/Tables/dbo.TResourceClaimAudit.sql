CREATE TABLE [dbo].[TResourceClaimAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ResourceClaimId] [int] NOT NULL,
[Resource] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Action] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TResourceClaimAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TResourceClaimAudit] ADD CONSTRAINT [PK_TResourceClaimAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO