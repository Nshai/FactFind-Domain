CREATE TABLE [dbo].[TRefTaxBasisAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefTaxBasisName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefTaxBasisId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTaxBasisAudit] ADD CONSTRAINT [PK_TRefTaxBasisAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefTaxBasisAudit_RefTaxBasisId_ConcurrencyId] ON [dbo].[TRefTaxBasisAudit] ([RefTaxBasisId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
