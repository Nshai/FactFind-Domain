CREATE TABLE [dbo].[TSupportUserCertificate]
(
[SupportUserCertificateId] [uniqueidentifier] NOT NULL,
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[DisplayName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Email] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Issuer] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[Subject] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[ValidFrom] [datetime] NULL,
[ValidUntil] [datetime] NULL,
[SerialNumber] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsRevoked] [bit] NULL,
[IsDeleted] [bit] NULL,
[HasExpired] [bit] NULL,
[LastCheckedOn] [datetime] NULL CONSTRAINT [DF_TSupportUserCertificate_LastCheckedOn] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[TSupportUserCertificate] ADD CONSTRAINT [PK_TSupportUserCertificate] PRIMARY KEY NONCLUSTERED  ([SupportUserCertificateId]) WITH (FILLFACTOR=80)
GO
