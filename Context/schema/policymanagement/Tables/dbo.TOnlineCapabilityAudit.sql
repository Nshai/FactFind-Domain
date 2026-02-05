CREATE TABLE [dbo].[TOnlineCapabilityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NULL,
[ProdSubTypeId] [int] NULL,
[RefProdProviderId] [int] NULL,
[OnlineProductId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[OnlineCapabilityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOnlineCapabilityAudit] ADD CONSTRAINT [PK_TOnlineCapabilityAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TOnlineCapabilityAudit_OnlineCapabilityId_ConcurrencyId] ON [dbo].[TOnlineCapabilityAudit] ([OnlineCapabilityId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
