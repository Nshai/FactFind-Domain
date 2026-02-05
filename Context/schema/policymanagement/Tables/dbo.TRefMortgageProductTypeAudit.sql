CREATE TABLE [dbo].[TRefMortgageProductTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[MortgageProductType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefMortgageProductTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefMortgageProductTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefMortgageProductTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefMortgageProductTypeAudit] ADD CONSTRAINT [PK_TRefMortgageProductTypeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
