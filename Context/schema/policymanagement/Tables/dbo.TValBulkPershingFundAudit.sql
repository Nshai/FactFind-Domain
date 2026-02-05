CREATE TABLE [dbo].[TValBulkPershingFundAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ValBulkPershingFundId] [int] NOT NULL,
[SedolCode] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[FundName] [nvarchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValBulkPershingFundAudit] ADD CONSTRAINT [PK_TValBulkPershingFundAudit] PRIMARY KEY CLUSTERED  ([AuditId])