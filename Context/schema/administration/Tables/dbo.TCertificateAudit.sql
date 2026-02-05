CREATE TABLE [dbo].[TCertificateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Issuer] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[Subject] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[ValidFrom] [datetime] NULL,
[ValidUntil] [datetime] NULL,
[SerialNumber] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsRevoked] [bit] NULL,
[HasExpired] [bit] NULL,
[LastCheckedOn] [datetime] NULL,
[CreatedDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCertificateAudit_ConcurrencyId] DEFAULT ((0)),
[CertificateId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCertificateAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCertificateAudit] ADD CONSTRAINT [PK_TCertificateAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCertificateAudit_CertificateId_ConcurrencyId] ON [dbo].[TCertificateAudit] ([CertificateId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
