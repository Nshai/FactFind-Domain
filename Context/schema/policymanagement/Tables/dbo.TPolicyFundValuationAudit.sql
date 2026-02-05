CREATE TABLE [dbo].[TPolicyFundValuationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyFundId] [int] NULL,
[FundValue] [money] NULL,
[FundValuationDate] [datetime] NULL,
[UpdatedByUserId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyFun_ConcurrencyId_2__56] DEFAULT ((1)),
[PolicyFundValuationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyFun_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyFundValuationAudit] ADD CONSTRAINT [PK_TPolicyFundValuationAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyFundValuationAudit_PolicyFundValuationId_ConcurrencyId] ON [dbo].[TPolicyFundValuationAudit] ([PolicyFundValuationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
