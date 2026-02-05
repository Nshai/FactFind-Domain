CREATE TABLE [dbo].[TRefInvestmentTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[InvestmentType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefInvestmentTypeAudit_ConcurrencyId] DEFAULT ((0)),
[RefInvestmentTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefInvestmentTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefInvestmentTypeAudit] ADD CONSTRAINT [PK_TRefInvestmentTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefInvestmentTypeAudit_RefInvestmentTypeId_ConcurrencyId] ON [dbo].[TRefInvestmentTypeAudit] ([RefInvestmentTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
