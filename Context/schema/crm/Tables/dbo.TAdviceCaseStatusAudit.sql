CREATE TABLE [dbo].[TAdviceCaseStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusAudit_TenantId] DEFAULT ((1)),
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusAudit_DefaultFg] DEFAULT ((0)),
[IsComplete] [bit] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusAudit_IsComplete] DEFAULT ((0)),
[IsAutoClose] [bit] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusAudit_IsAutoClose] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseStatusAudit] ADD CONSTRAINT [PK_TAdviceCaseStatusAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviceCaseStatusAudit_AdviceCaseStatusId_ConcurrencyId] ON [dbo].[TAdviceCaseStatusAudit] ([AdviceCaseStatusId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
