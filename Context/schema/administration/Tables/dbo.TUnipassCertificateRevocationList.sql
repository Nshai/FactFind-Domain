CREATE TABLE [dbo].[TUnipassCertificateRevocationList]
(
[UnipassCertificateRevocationListId] [uniqueidentifier] NOT NULL,
[SerialNumber] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsAG2MCertificate] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TUnipassCertificateRevocationList] ADD CONSTRAINT [PK_TUnipassCertificateRevocationList] PRIMARY KEY CLUSTERED  ([UnipassCertificateRevocationListId])
GO
