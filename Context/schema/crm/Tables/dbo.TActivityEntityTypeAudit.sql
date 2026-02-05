CREATE TABLE [dbo].[TActivityEntityTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ActivityEntityTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ActivityEntityTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TActivityEntityTypeAudit] ADD CONSTRAINT [PK_TActivityEntityTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
