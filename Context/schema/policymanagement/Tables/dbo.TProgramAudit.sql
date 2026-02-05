CREATE TABLE [dbo].[TProgramAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProgramId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Name] [varchar] (50) NOT NULL,
[CreatedBy] [int] NOT NULL,
[CreatedAt] [datetime] NOT NULL,
[ModifiedBy] [int] NULL,
[ModifiedAt] [datetime] NULL,
[DoesAllowTrading] [bit] NOT NULL CONSTRAINT [DF_TProgramAudit_DoesAllowTrading] Default(0),
[Status] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TProgramAudit_Status] DEFAULT (N'Draft'),
[Description] [nvarchar] (1000) NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProgramAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TProgramAudit] ADD CONSTRAINT [PK_TProgramAudit_AuditId] PRIMARY KEY CLUSTERED ([AuditId])
GO

CREATE NONCLUSTERED INDEX [IDX_TProgramAudit_ProgramId] ON [dbo].[TProgramAudit] ([ProgramId])
GO