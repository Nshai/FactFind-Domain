CREATE TABLE [dbo].[TCertificate]
(
[CertificateId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
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
[CreatedDate] [datetime] NULL CONSTRAINT [DF_TCertificate_CreatedDate] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCertificate_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TCertificate] ADD CONSTRAINT [PK_TCertificate] PRIMARY KEY NONCLUSTERED  ([CertificateId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TCertificate_CrmContactId] ON [dbo].[TCertificate] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TCertificate_UserId] ON [dbo].[TCertificate] ([UserId])
GO
