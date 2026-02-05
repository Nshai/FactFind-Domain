CREATE TABLE [dbo].[TRefTaxRateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[TaxRate] [decimal] (10, 1) NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefTaxRateAudit_IsArchived] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefTaxRateId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefTaxRateAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTaxRateAudit] ADD CONSTRAINT [PK_TRefTaxRateAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefTaxRateAudit_RefTaxRateId_ConcurrencyId] ON [dbo].[TRefTaxRateAudit] ([RefTaxRateId], [ConcurrencyId]) WITH (FILLFACTOR=75)
GO
