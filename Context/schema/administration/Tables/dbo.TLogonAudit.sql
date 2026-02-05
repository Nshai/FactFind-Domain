CREATE TABLE [dbo].[TLogonAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[LogonDateTime] [datetime] NOT NULL,
[LogoffDateTime] [datetime] NULL,
[Type] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[SourceAddress] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLogonAudit_ConcurrencyId] DEFAULT ((1)),
[LogonId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLogonAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CertificateSerialNumber] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[ExternalApplication] [varchar](100) NULL
)
GO
ALTER TABLE [dbo].[TLogonAudit] ADD CONSTRAINT [PK_TLogonAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
