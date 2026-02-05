CREATE TABLE [dbo].[TFilePollingProcess]
(
[FilePollingProcessId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[WatchingFolder] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[IsEnabled] [bit] NOT NULL,
[PollingInterval] [int] NOT NULL,
[HasLimitInterval] [bit] NOT NULL,
[IntervalFrom] [int] NOT NULL,
[IntervalTo] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFilePollingProcess_ConcurrencyId] DEFAULT ((0)),
[NotificationEmails] [varchar] (500) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFilePollingProcess] ADD CONSTRAINT [PK_TFilePollingProcess] PRIMARY KEY CLUSTERED  ([FilePollingProcessId])
GO
