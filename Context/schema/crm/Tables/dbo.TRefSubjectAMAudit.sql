CREATE TABLE [dbo].[TRefSubjectAMAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefSubjectAMId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefSubjec_StampDateTime_1__51] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefSubjectAMAudit] ADD CONSTRAINT [PK_TRefSubjectAMAudit_2__51] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefSubjectAMAudit_RefSubjectAMId_ConcurrencyId] ON [dbo].[TRefSubjectAMAudit] ([RefSubjectAMId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
