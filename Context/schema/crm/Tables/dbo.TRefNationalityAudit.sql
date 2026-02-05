CREATE TABLE [dbo].[TRefNationalityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefNationalityId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TRefNationality_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefNationalityAudit] ADD CONSTRAINT [PK_TRefNationalityAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
