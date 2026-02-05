CREATE TABLE [dbo].[TNextUiActionMessageAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ErrorMsg] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[Success] [bit] NOT NULL,
[IntegratedSystemId] [int] NULL,
[CustomData] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ProductTypeId] [int] NULL,
[SagaId] [uniqueidentifier] NOT NULL,
[IntegratedSystemAccountId] [int] NULL,
[ProductTypeCode] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IntegratedSystemCode] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedDate] [datetime] NULL,
[NextUiActionMessageId] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TNextUiActionMessageAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNextUiActionMessageAudit] ADD CONSTRAINT [PK_TNextUiActionMessageAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
