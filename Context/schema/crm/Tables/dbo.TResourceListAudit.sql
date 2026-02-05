CREATE TABLE [dbo].[TResourceListAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[CalenderFG] [bit] NOT NULL CONSTRAINT [DF_TResourceListAudit_CalenderFG] DEFAULT ((0)),
[IndClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TResourceListAudit_ConcurrencyId] DEFAULT ((1)),
[ResourceListId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TResourceListAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TResourceListAudit] ADD CONSTRAINT [PK_TResourceListAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
