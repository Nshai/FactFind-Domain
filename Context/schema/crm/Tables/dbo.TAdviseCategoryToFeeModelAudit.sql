CREATE TABLE [dbo].[TAdviseCategoryToFeeModelAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviseCategoryId] [int] NOT NULL,
[FeeModelId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AdviseCategoryToFeeModelId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviseCategoryToFeeModelAudit] ADD CONSTRAINT [PK_TAdviseCategoryToFeeModelAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
