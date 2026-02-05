CREATE TABLE [dbo].[TLogon]
(
[LogonId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UserId] [int] NOT NULL,
[LogonDateTime] [datetime] NOT NULL,
[LogoffDateTime] [datetime] NULL,
[Type] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[SourceAddress] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLogon_ConcurrencyId] DEFAULT ((1)),
[CertificateSerialNumber] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[ExternalApplication] [varchar](100) NULL
)
GO
 
ALTER TABLE [dbo].[TLogon] ADD CONSTRAINT [PK_TLogon] PRIMARY KEY NONCLUSTERED  ([LogonId])
GO
CREATE CLUSTERED INDEX [CLX_TLogon_UserId] ON [dbo].[TLogon] ([UserId])
GO
