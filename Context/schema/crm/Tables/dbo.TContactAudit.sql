CREATE TABLE [dbo].[TContactAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[RefContactType] [varchar] (50)  NOT NULL,
[Description] [varchar] (8000)  NULL,
[Value] [varchar] (255)  NULL,
[DefaultFg] [tinyint] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[ContactId] [int] NOT NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TContactAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NULL,
[MigrationRef] [varchar] (255)  NULL,
[FormattedPhoneNumber] [varchar] (255) NULL,
[CreatedOn] [datetime] NULL,
[CreatedByUserId] [int] NULL,
[UpdatedOn] [datetime] NULL,
[UpdatedByUserId] [int] NULL

)
GO
ALTER TABLE [dbo].[TContactAudit] ADD CONSTRAINT [PK_TContactAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TContactAudit_ContactId_ConcurrencyId] ON [dbo].[TContactAudit] ([ContactId], [ConcurrencyId])
GO
CREATE NONCLUSTERED INDEX [IX_TContactAudit_StampDateTime_ContactId] ON [dbo].[TContactAudit] ([StampDateTime], [ContactId])
GO
