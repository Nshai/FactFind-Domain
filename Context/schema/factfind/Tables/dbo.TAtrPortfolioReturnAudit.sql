CREATE TABLE [dbo].[TAtrPortfolioReturnAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrPortfolioGuid] [uniqueidentifier] NOT NULL,
[AtrRefPortfolioTermId] [int] NOT NULL,
[LowerReturn] [decimal] (10, 4) NULL,
[MidReturn] [decimal] (10, 4) NULL,
[UpperReturn] [decimal] (10, 4) NULL,
[Guid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrPortfolioReturnAudit_ConcurrencyId] DEFAULT ((1)),
[AtrPortfolioReturnId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrPortfolioReturnAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrPortfolioReturnAudit] ADD CONSTRAINT [PK_TAtrPortfolioReturnAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrPortfolioReturnAudit_AtrPortfolioReturnId_ConcurrencyId] ON [dbo].[TAtrPortfolioReturnAudit] ([AtrPortfolioReturnId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
