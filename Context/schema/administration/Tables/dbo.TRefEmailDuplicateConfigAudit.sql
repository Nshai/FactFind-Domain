CREATE TABLE [dbo].[TRefEmailDuplicateConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DuplicateConfigName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTRefEmailDuplicateConfigAudit_ConcurrencyId] DEFAULT ((1)),
[RefEmailDuplicateConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefEmailDuplicateConfigAudit] ADD CONSTRAINT [PK_TTRefEmailDuplicateConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
