CREATE TABLE [dbo].[TRefApplicationCustomHandlerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefApplicationCustomHandlerId] [int] NULL,
[RefApplicationId] [int] NULL,
[HandlerPath] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NULL,
[ConcurrencyId] [int] NULL,
[IntegratedSystemConfigRole] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefApplicationCustomHandlerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefApplicationCustomHandlerAudit] ADD CONSTRAINT [PK_TRefApplicationCustomHandlerAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO