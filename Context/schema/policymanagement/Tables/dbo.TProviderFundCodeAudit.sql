CREATE TABLE [dbo].[TProviderFundCodeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[ProviderFundCode] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[FundId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProviderFundCodeAudit_ConcurrencyId] DEFAULT ((1)),
[ProviderFundCodeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProviderFundCodeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProviderFundCodeAudit] ADD CONSTRAINT [PK_TProviderFundCodeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProviderFundCodeAudit_ProviderFundCodeId_ConcurrencyId] ON [dbo].[TProviderFundCodeAudit] ([ProviderFundCodeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
