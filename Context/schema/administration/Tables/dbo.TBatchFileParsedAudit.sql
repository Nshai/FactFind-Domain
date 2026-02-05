CREATE TABLE [dbo].[TBatchFileParsedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBatchFileParsedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[BatchFileParsedId] [int] NOT NULL,
[BatchFileProcessId][int] NOT NULL,
[FileName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsSuccess] [bit] NOT NULL,
[StatusDescription] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NULL,
[DateProcessed] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TBatchFileParsedAudit] ADD CONSTRAINT [PK_TBatchFileParsedAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
