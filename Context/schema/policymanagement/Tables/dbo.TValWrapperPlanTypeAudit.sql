CREATE TABLE [dbo].[TValWrapperPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ValGatingId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValWrapperPlanTypeAudit_ConcurrencyId] DEFAULT ((1)),
[ValWrapperPlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValWrapperPlanTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValWrapperPlanTypeAudit] ADD CONSTRAINT [PK_TValWrapperPlanTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TValWrapperPlanTypeAudit_ValWrapperPlanTypeId_ConcurrencyId] ON [dbo].[TValWrapperPlanTypeAudit] ([ValWrapperPlanTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
