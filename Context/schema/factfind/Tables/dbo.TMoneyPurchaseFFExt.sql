CREATE TABLE [dbo].[TMoneyPurchaseFFExt]
(
[MoneyPurchaseFFExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NonDisclosure] [bit] NULL,
[ExistingMoneyPurchaseSchemes] [bit] NULL,
[SSPContractedOut] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_TMoneyPurchaseFFExt_CRMContactId] ON [dbo].[TMoneyPurchaseFFExt] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
