CREATE TABLE [dbo].[TMortgageMiscellaneous]
(
[MortgageMiscellaneousId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageMiscellaneous_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NULL,
[HasExistingProvision] [bit] NULL,
[HasAdverseCreditHistory] [bit] NULL,
[NumberOfExistingMortgages] [int] NULL,
[Notes] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[HasRefusedCredit] [bit] NULL,
[RefusedCredit] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[HasEquityRelease] [bit] NULL
)
GO
ALTER TABLE [dbo].[TMortgageMiscellaneous] ADD CONSTRAINT [PK_TMortgageMiscellaneous] PRIMARY KEY NONCLUSTERED  ([MortgageMiscellaneousId])
GO
CREATE NONCLUSTERED INDEX IX_TMortgageMiscellaneous_CRMContactId ON [dbo].[TMortgageMiscellaneous] ([CRMContactId]) 
go