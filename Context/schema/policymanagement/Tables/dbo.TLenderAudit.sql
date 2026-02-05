CREATE TABLE [dbo].[TLenderAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LenderName] [varchar] (120) COLLATE Latin1_General_CI_AS NOT NULL,
[Url] [varchar] (120) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLenderAudit_ConcurrencyId] DEFAULT ((1)),
[LenderId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLenderAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLenderAudit] ADD CONSTRAINT [PK_TLenderAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
