CREATE TABLE [dbo].[TBatchFileLineError]
(
[BatchFileLineErrorId] [int] NOT NULL IDENTITY(1, 1),
[BatchFileParsedId] [int] NOT NULL,
[LineNumber] [int] NOT NULL,
[Error] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[LineData] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Identifier] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RecordType] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_TBatchFileLineError_RecordType] DEFAULT ('Empty'),
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TBatchFileLineError_ConcurrencyId] DEFAULT ((1)),
)
GO
ALTER TABLE [dbo].[TBatchFileLineError] ADD CONSTRAINT [PK_TBatchFileLineError] PRIMARY KEY CLUSTERED  ([BatchFileLineErrorId])
GO
