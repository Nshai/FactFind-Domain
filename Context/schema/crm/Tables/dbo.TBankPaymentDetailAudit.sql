CREATE TABLE [dbo].[TBankPaymentDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndClientId] [int] NOT NULL,
[BankDetailId] [int] NOT NULL,
[CRMOwnerId] [int] NOT NULL,
[RefPaymentTypeId] [int] NOT NULL,
[PayByChequeFg] [tinyint] NOT NULL CONSTRAINT [DF_TBankPayme_PayByChequeFg_2__56] DEFAULT ((0)),
[BlockedFg] [tinyint] NOT NULL CONSTRAINT [DF_TBankPayme_BlockedFg_1__56] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[BankPaymentDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBankPayme_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBankPaymentDetailAudit] ADD CONSTRAINT [PK_TBankPaymentDetailAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TBankPaymentDetailAudit_BankPaymentDetailId_ConcurrencyId] ON [dbo].[TBankPaymentDetailAudit] ([BankPaymentDetailId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
