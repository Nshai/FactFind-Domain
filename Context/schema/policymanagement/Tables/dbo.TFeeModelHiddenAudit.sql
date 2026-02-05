CREATE TABLE [dbo].[TFeeModelHiddenAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelHiddenId] [int] NOT NULL,
[FeeModelId] [int] NOT NULL,
[GroupId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeModelHiddenAudit] ADD CONSTRAINT [PK_TFeeModelHiddenAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
