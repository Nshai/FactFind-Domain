CREATE TABLE [dbo].[TRefFileImportStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefFileImportStatusId] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [nchar] (10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TRefFileImportStatusAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TREfFileImportStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [nchar] (10) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefFileImportStatusAudit] ADD CONSTRAINT [PK_TFileImportStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
