CREATE TABLE [dbo].[TAtrMatrixAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrRefMatrixDurationId] [int] NULL,
[ImmediateIncome] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[RiskProfileGuid] [uniqueidentifier] NOT NULL,
[AtrPortfolioGuid] [uniqueidentifier] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[AtrMatrixTermGuid] [uniqueidentifier] NULL,
[Guid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NULL,
[AtrMatrixId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrMatrixAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrMatrixAudit] ADD CONSTRAINT [PK_TAtrMatrixAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrMatrixAudit_AtrMatrixId_ConcurrencyId] ON [dbo].[TAtrMatrixAudit] ([AtrMatrixId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
