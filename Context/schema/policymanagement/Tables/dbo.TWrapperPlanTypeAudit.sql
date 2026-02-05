CREATE TABLE [dbo].[TWrapperPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[WrapperProviderId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TWrapperPlanTypeAudit_ConcurrencyId] DEFAULT ((1)),
[WrapperPlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TWrapperPlanTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TWrapperPlanTypeAudit] ADD CONSTRAINT [PK_TWrapperPlanTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TWrapperPlanTypeAudit_WrapperPlanTypeId_ConcurrencyId] ON [dbo].[TWrapperPlanTypeAudit] ([WrapperPlanTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
