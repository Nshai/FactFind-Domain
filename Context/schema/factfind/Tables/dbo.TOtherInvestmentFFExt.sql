CREATE TABLE [dbo].[TOtherInvestmentFFExt]
(
[OtherInvestmentFFExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NonDisclosure] [bit] NULL,
[ExistingOtherInvestments] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_TOtherInvestmentFFExt_CRMContactId] ON [dbo].[TOtherInvestmentFFExt] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
