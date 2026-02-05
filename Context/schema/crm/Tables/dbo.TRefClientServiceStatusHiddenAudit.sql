CREATE TABLE [dbo].[TRefClientServiceStatusHiddenAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefClientServiceStatusHiddenId] [int] NOT NULL,
[RefServiceStatusId] [int] NOT NULL,
[GroupId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefClientServiceStatusHiddenAudit] ADD CONSTRAINT [PK_TRefClientServiceStatusHiddenAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
