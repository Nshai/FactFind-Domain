CREATE TABLE [dbo].[TPolicyFundAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NULL CONSTRAINT [DF_TPolicyFun_PolicyBusinessId_3__56] DEFAULT ((0)),
[FundId] [int] NULL CONSTRAINT [DF_TPolicyFun_FundId_2__56] DEFAULT ((0)),
[FundProviderId] [int] NULL,
[RefUnitTypeId] [int] NULL,
[RefPriceBasisId] [int] NULL,
[PurchasePrice] [money] NULL,
[PurchaseDate] [datetime] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyFun_ConcurrencyId_1__56] DEFAULT ((1)),
[PolicyFundId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyFun_StampDateTime_4__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyFundAudit] ADD CONSTRAINT [PK_TPolicyFundAudit_8__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyFundAudit_PolicyFundId_ConcurrencyId] ON [dbo].[TPolicyFundAudit] ([PolicyFundId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
