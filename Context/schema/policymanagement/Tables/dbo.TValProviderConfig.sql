CREATE TABLE [dbo].[TValProviderConfig]
(
[ValProviderConfigId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefProdProviderId] [int] NOT NULL,
[ValuationProviderCode] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PostURL] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[OrigoResponderId] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AuthenticationType] [tinyint] NULL,
[IsAsynchronous] [bit] NOT NULL CONSTRAINT [DF_TValProviderConfig_IsAsynchronous] DEFAULT ((0)),
[HowToXML] [varchar] (6000) COLLATE Latin1_General_CI_AS NULL,
[AllowRetry] [bit] NOT NULL CONSTRAINT [DF_TValProviderConfig_AllowRetry] DEFAULT ((0)),
[RetryDelay] [int] NULL,
[BulkValuationType] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[FileAccessCredentialsRequired] [bit] NOT NULL CONSTRAINT [DF_TValProviderConfig_FileAccessCredentialsRequired] DEFAULT ((0)),
[PasswordEncryption] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ScheduleDelay] [int] NOT NULL CONSTRAINT [DF_TValProviderConfig_ScheduleDelay] DEFAULT ((0)),
[SupportedService] [int] NULL,
[ReEncodeResponseTo] [varchar] (25) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValProviderConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValProviderConfig] ADD CONSTRAINT [PK_TValProviderConfig] PRIMARY KEY CLUSTERED  ([ValProviderConfigId]) WITH (FILLFACTOR=80)
GO
