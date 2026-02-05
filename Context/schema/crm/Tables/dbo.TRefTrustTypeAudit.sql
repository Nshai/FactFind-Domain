CREATE TABLE [dbo].[TRefTrustTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TrustTypeName] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [tinyint] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTrustT_ConcurrencyId_1__56] DEFAULT ((1)),
[RefTrustTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefTrustT_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTrustTypeAudit] ADD CONSTRAINT [PK_TRefTrustTypeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefTrustTypeAudit_RefTrustTypeId_ConcurrencyId] ON [dbo].[TRefTrustTypeAudit] ([RefTrustTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
