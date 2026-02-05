CREATE TABLE [dbo].[TQueryResultReferenceStoreAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Reference] [nchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[MIReportId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Data] [varbinary] (max) NOT NULL,
[CreatedTimeStamp] [datetime] NOT NULL CONSTRAINT [DF_TQueryResultReferenceStoreAudit_CreatedTimeStamp] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQueryResultReferenceStoreAudit_ConcurrencyId] DEFAULT ((1)),
[QueryResultReferenceStoreId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQueryResultReferenceStoreAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQueryResultReferenceStoreAudit] ADD CONSTRAINT [PK_TQueryResultReferenceStoreAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
