CREATE TABLE [dbo].[TClientActivityLog]
(
[ClientActivityLogId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Activity] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Application] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TimeStamp] [datetime] NOT NULL CONSTRAINT [DF_TClientActivityLog_TimeStamp] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientActivityLog_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TClientActivityLog] ADD CONSTRAINT [PK_TClientActivityLog] PRIMARY KEY NONCLUSTERED  ([ClientActivityLogId]) WITH (FILLFACTOR=80)
GO
