CREATE TABLE [dbo].[TDatabaseVersionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DatabaseVersion] [numeric] (8, 4) NULL,
[VersionDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDatabaseV_ConcurrencyId_1__56] DEFAULT ((1)),
[DatabaseVersionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDatabaseV_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDatabaseVersionAudit] ADD CONSTRAINT [PK_TDatabaseVersionAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TDatabaseVersionAudit_DatabaseVersionId_ConcurrencyId] ON [dbo].[TDatabaseVersionAudit] ([DatabaseVersionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
