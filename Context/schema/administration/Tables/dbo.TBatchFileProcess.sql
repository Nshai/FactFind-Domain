CREATE TABLE [dbo].[TBatchFileProcess]
(
[BatchFileProcessId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[NotificationEmails] [nvarchar](max) NULL,
[ApplicationLinkId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TBatchFileProcess_ConcurrencyId] DEFAULT ((1)),

)
GO
ALTER TABLE [dbo].[TBatchFileProcess] ADD CONSTRAINT [PK_TBatchFileProcess] PRIMARY KEY CLUSTERED  ([BatchFileProcessId])
GO
