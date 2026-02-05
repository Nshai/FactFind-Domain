CREATE TABLE [dbo].[TNextUiActionMessage]
(
[NextUiActionMessageId] [uniqueidentifier] NOT NULL,
[ErrorMsg] [varchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[Success] [bit] NOT NULL,
[IntegratedSystemId] [int] NULL,
[CustomData] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ProductTypeId] [int] NULL,
[SagaId] [uniqueidentifier] NOT NULL,
[IntegratedSystemAccountId] [int] NULL,
[ProductTypeCode] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IntegratedSystemCode] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TNextUiActionMessage_CreatedDate] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[TNextUiActionMessage] ADD CONSTRAINT [PK_TNextUiActionMessage] PRIMARY KEY NONCLUSTERED  ([NextUiActionMessageId])
GO
CREATE NONCLUSTERED INDEX [IX_TNextUiActionMessage_SagaId] ON [dbo].[TNextUiActionMessage] ([SagaId])
GO
