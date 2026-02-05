CREATE TABLE [dbo].[TValProviderConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[ValuationProviderCode] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PostURL] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[OrigoResponderId] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AuthenticationType] [tinyint] NULL,
[IsAsynchronous] [bit] NOT NULL CONSTRAINT [DF_TValProviderConfigAudit_IsAsynchronous] DEFAULT ((0)),
[HowToXML] [varchar] (6000) COLLATE Latin1_General_CI_AS NULL,
[AllowRetry] [bit] NOT NULL CONSTRAINT [DF_TValProviderConfigAudit_AllowRetry] DEFAULT ((0)),
[RetryDelay] [int] NULL,
[BulkValuationType] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[FileAccessCredentialsRequired] [bit] NOT NULL CONSTRAINT [DF_TValProviderConfigAudit_FileAccessCredentialsRequired] DEFAULT ((0)),
[PasswordEncryption] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ScheduleDelay] [int] NOT NULL CONSTRAINT [DF_TValProviderConfigAudit_ScheduleDelay] DEFAULT ((0)),
[SupportedService] [int] NULL,
[ReEncodeResponseTo] [varchar] (25) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValProviderConfigAudit_ConcurrencyId] DEFAULT ((1)),
[ValProviderConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValProviderConfigAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValProviderConfigAudit] ADD CONSTRAINT [PK_TValProviderConfigAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
