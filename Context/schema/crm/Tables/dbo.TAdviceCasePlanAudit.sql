CREATE TABLE [dbo].[TAdviceCasePlanAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCasePlanAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCasePlanId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCasePlanAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TAdviceCasePlanAudit] ADD CONSTRAINT [PK_TAdviceCasePlanAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviceCasePlanAudit_AdviceCasePlanId_ConcurrencyId] ON [dbo].[TAdviceCasePlanAudit] ([AdviceCasePlanId], [ConcurrencyId])
GO
