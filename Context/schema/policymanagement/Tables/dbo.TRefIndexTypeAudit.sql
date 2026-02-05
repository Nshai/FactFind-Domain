CREATE TABLE [dbo].[TRefIndexTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndexTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefIndexTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefIndexTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefIndexTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefIndexTypeAudit] ADD CONSTRAINT [PK_TRefIndexTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
