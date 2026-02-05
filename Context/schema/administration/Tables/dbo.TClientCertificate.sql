CREATE TABLE [dbo].[TClientCertificate]
(
[ClientCertificateId] [int] NOT NULL IDENTITY(1, 1),
[KeyIdentifier] [varchar] (255)  NOT NULL,
[SerialNo] [varchar] (255)  NULL,
[Description] [varchar] (1000)  NULL,
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientCertificate_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TClientCertificate] ADD CONSTRAINT [PK_TClientCertificate] PRIMARY KEY NONCLUSTERED  ([ClientCertificateId])
GO
ALTER TABLE [dbo].[TClientCertificate] WITH CHECK ADD CONSTRAINT [FK_TClientCertificate_TIndigoClient] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TClientCertificate] WITH CHECK ADD CONSTRAINT [FK_TClientCertificate_TUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
