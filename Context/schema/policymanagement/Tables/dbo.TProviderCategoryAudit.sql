CREATE TABLE [dbo].[TProviderCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[RefPlanCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProviderC_ConcurrencyId_1__57] DEFAULT ((1)),
[ProviderCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProviderC_StampDateTime_2__57] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProviderCategoryAudit] ADD CONSTRAINT [PK_TProviderCategoryAudit_3__57] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TProviderCategoryAudit_ProviderCategoryId_ConcurrencyId] ON [dbo].[TProviderCategoryAudit] ([ProviderCategoryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
