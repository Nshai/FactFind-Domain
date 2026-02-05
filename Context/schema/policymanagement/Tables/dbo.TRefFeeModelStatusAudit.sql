CREATE TABLE [dbo].[TRefFeeModelStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefFeeModelStatusId] [int] NOT NULL,
[Status] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefFeeModelStatusAudit] ADD CONSTRAINT [PK_TRefFeeModelStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
