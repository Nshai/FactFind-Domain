CREATE TABLE [dbo].[TAtrPortfolioReturnCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrPortfolioReturnId] [int] NOT NULL,
[AtrPortfolioGuid] [uniqueidentifier] NOT NULL,
[AtrRefPortfolioTermId] [int] NOT NULL,
[LowerReturn] [decimal] (10, 4) NULL,
[MidReturn] [decimal] (10, 4) NULL,
[UpperReturn] [decimal] (10, 4) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrPortfolioReturnCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[Guid] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrPortfolioReturnCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrPortfolioReturnCombinedAudit] ADD CONSTRAINT [PK_TAtrPortfolioReturnCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrPortfolioReturnCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TAtrPortfolioReturnCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
