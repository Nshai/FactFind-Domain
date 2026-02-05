CREATE TABLE [dbo].[TRefFileImportTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFileImportTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefFileImportTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TRefFileImportTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefFileImportTypeAudit] ADD CONSTRAINT [PK_TRefFileImportTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
