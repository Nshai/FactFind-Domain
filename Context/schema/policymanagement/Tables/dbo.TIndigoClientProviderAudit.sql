CREATE TABLE [dbo].[TIndigoClientProviderAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NULL,
[IndigoClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoCli_ConcurrencyId_1__56] DEFAULT ((1)),
[IndigoClientProviderId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIndigoCli_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientProviderAudit] ADD CONSTRAINT [PK_TIndigoClientProviderAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TIndigoClientProviderAudit_IndigoClientProviderId_ConcurrencyId] ON [dbo].[TIndigoClientProviderAudit] ([IndigoClientProviderId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
