CREATE TABLE [dbo].[TAtrMatrixCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrMatrixId] [int] NOT NULL,
[ImmediateIncome] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[RiskProfileGuid] [uniqueidentifier] NOT NULL,
[AtrPortfolioGuid] [uniqueidentifier] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[AtrMatrixTermGuid] [uniqueidentifier] NULL,
[Guid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrMatrixCombinedAudit] ADD CONSTRAINT [PK_TAtrMatrixCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrMatrixCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TAtrMatrixCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
