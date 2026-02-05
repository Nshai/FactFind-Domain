CREATE TABLE [dbo].[TFee2PolicyFundAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NULL,
[PolicyBusinessId] [int] NULL,
[Rate] [float] NULL,
[RefValuationBasisId] [int] NULL,
[ValuationStartDate] [datetime] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL,
[Fee2PolicyFundId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFee2Polic_StampDateTime_2__60] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFee2PolicyFundAudit] ADD CONSTRAINT [PK_TFee2PolicyFundAudit_3__60] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFee2PolicyFundAudit_Fee2PolicyFundId_ConcurrencyId] ON [dbo].[TFee2PolicyFundAudit] ([Fee2PolicyFundId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
