CREATE TABLE [dbo].[TProgramFeeModelAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProgramFeeModelId] [int] NOT NULL,
[ProgramId] [int] NOT NULL,
[FeeModelId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProgramFeeModelAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TProgramFeeModelAudit] ADD CONSTRAINT [PK_TProgramFeeModelAudit_AuditId] PRIMARY KEY CLUSTERED ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProgramFeeModelAudit] ON [dbo].[TProgramFeeModelAudit] ([FeeModelId])
GO
