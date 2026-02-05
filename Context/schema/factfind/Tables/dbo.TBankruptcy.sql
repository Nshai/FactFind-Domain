CREATE TABLE [dbo].[TBankruptcy]
(
[BankruptcyId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[bankruptcyDischargedFg] [bit] NULL,
[bankruptcyDate] [datetime] NULL,
[bankruptcyApp1] [bit] NULL,
[bankruptcyApp2] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBankruptcy_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TBankruptcy] ADD CONSTRAINT [PK_TBankruptcy] PRIMARY KEY NONCLUSTERED  ([BankruptcyId]) WITH (FILLFACTOR=80)
GO
