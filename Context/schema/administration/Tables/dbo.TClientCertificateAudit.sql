CREATE TABLE [dbo].[TClientCertificateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[KeyIdentifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[SerialNo] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientCertificateAudit_ConcurrencyId] DEFAULT ((0)),
[ClientCertificateId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientCertificateAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientCertificateAudit] ADD CONSTRAINT [PK_TClientCertificateAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TClientCertificateAudit_ClientCertificateId_ConcurrencyId] ON [dbo].[TClientCertificateAudit] ([ClientCertificateId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
