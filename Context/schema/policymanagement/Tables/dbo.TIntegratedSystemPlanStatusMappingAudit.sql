CREATE TABLE [dbo].[TIntegratedSystemPlanStatusMappingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationLinkId] [int] NOT NULL,
[ChangePlanStatusToInForce] [bit] NOT NULL CONSTRAINT [DF_TIntegratedSystemPlanStatusMappingAudit_ChangePlanStatusToInForce] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntegratedSystemPlanStatusMappingAudit_ConcurrencyId] DEFAULT ((1)),
[IntegratedSystemPlanStatusMappingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIntegratedSystemPlanStatusMappingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIntegratedSystemPlanStatusMappingAudit] ADD CONSTRAINT [PK_TIntegratedSystemPlanStatusMappingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIntegratedSystemPlanStatusMappingAudit_IntegratedSystemPlanStatusMappingId_ConcurrencyId] ON [dbo].[TIntegratedSystemPlanStatusMappingAudit] ([IntegratedSystemPlanStatusMappingId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
