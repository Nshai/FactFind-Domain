CREATE TABLE [dbo].[TGcdDailyBatchSagaData]
(
[GcdDailyBatchSagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[TotalLines] [int] NOT NULL,
[FileIdentifier] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[CompletedLines] [int] NOT NULL,
[Report] [ntext] COLLATE Latin1_General_CI_AS NULL,
[Errors] [int] NOT NULL,
[EmailAddress] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[FinalFileLocation] [nvarchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Completed] [bit] NOT NULL,
[StartTime] [datetime] NOT NULL,
[EndTime] [datetime] NULL,
[TenantId] [int] NOT NULL,
[IsDeleted] [bit] NULL
)
GO
