CREATE TABLE [dbo].[TRefProdProviderPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefProdPr_ConcurrencyId_1__56] DEFAULT ((1)),
[RefProdProviderPlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefProdPr_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefProdProviderPlanTypeAudit] ADD CONSTRAINT [PK_TRefProdProviderPlanTypeAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefProdProviderPlanTypeAudit_RefProdProviderPlanTypeId_ConcurrencyId] ON [dbo].[TRefProdProviderPlanTypeAudit] ([RefProdProviderPlanTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
