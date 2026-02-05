CREATE TABLE [dbo].[TTrusteeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PersonId] [int] NOT NULL,
[CorporateId] [int] NOT NULL,
[DefaultFG] [tinyint] NOT NULL,
[ArchiveFG] [tinyint] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[TrusteeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTrusteeAu_StampDateTime_1__54] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTrusteeAudit] ADD CONSTRAINT [PK_TTrusteeAudit_2__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TTrusteeAudit_TrusteeId_ConcurrencyId] ON [dbo].[TTrusteeAudit] ([TrusteeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
