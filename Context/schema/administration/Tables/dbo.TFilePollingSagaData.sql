CREATE TABLE [dbo].[TFilePollingSagaData]
(
[FilePollingSagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[FilePollingProcessId] [int] NOT NULL,
[Identifier] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[WatchingFolder] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PollingInterval] [int] NOT NULL,
[HasLimitInterval] [bit] NOT NULL,
[IntervalFrom] [int] NOT NULL,
[IntervalTo] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[KeepPolling] [bit] NOT NULL,
[NotificationEmails] [varchar] (500) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFilePollingSagaData] ADD CONSTRAINT [PK__TFilePol__F23FB0AC18B7765F] PRIMARY KEY CLUSTERED  ([FilePollingSagaDataId])
GO
