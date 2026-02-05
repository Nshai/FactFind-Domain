CREATE TABLE [dbo].[TProtectionMiscellaneous]
(
[ProtectionMiscellaneousId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProtectionMiscellaneous_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[HasExistingProvision] [bit] NULL,
[NonDisclosure] [bit] NULL,
[Notes] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[IncomeReplacementRate] [smallint] NULL
)
GO
ALTER TABLE [dbo].[TProtectionMiscellaneous] ADD CONSTRAINT [PK_TProtectionMiscellaneous] PRIMARY KEY NONCLUSTERED  ([ProtectionMiscellaneousId])
GO
CREATE NONCLUSTERED INDEX IX_TProtectionMiscellaneous_CRMContactID ON [dbo].[TProtectionMiscellaneous] ([CRMContactId])  INCLUDE ([Notes]) 
GO
