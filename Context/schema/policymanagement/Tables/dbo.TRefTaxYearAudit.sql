CREATE TABLE [dbo].[TRefTaxYearAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefTaxYearName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefTaxYearId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTaxYearAudit] ADD CONSTRAINT [PK_TRefTaxYearAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefTaxYearAudit_RefTaxYearId_ConcurrencyId] ON [dbo].[TRefTaxYearAudit] ([RefTaxYearId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
