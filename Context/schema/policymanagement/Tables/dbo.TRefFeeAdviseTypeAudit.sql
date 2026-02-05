CREATE TABLE [dbo].[TRefFeeAdviseTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefFeeAdviseTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefFeeAdviseTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefFeeAdviseTypeAudit] ADD CONSTRAINT [PK_TRefFeeAdviseTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
