CREATE TABLE [dbo].[TSupportUserCertificateRevocationList]
(
[SupportUserCertificateRevocationListId] [uniqueidentifier] NOT NULL,
[SerialNumber] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSupportUserCertificateRevocationList] ADD CONSTRAINT [PK_TSupportUserCertificateRevocationList] PRIMARY KEY CLUSTERED  ([SupportUserCertificateRevocationListId])
GO
