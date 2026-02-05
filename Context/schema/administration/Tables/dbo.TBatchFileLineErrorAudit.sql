CREATE TABLE [dbo].[TBatchFileLineErrorAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBatchFileLineErrorAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[BatchFileLineErrorId] [int] NOT NULL,
[LineNumber] [int] NOT NULL,
[Error] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[LineData] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[BatchFileParsedId] [int] NOT NULL,
[Identifier] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RecordType] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TBatchFileLineErrorAudit] ADD CONSTRAINT [PK_TBatchFileLineErrorAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
