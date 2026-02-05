CREATE TABLE [dbo].[TClientBankAccount]
(
[ClientBankAccountId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[BankName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AddressLine1] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine2] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine3] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AddressLine4] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[CityTown] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefCountyId] [int] NULL,
[RefCountryId] [int] NULL,
[PostCode] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[AccountHolders] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AccountNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SortCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AccountName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DefaultAccountFg] [bit] NOT NULL CONSTRAINT [DF_TClientBankAccount_DefaultAccountFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientBankAccount_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TClientBankAccount] ADD CONSTRAINT [PK_TClientBankAccount] PRIMARY KEY NONCLUSTERED  ([ClientBankAccountId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TClientBankAccount] ADD CONSTRAINT [FK_TClientBankAccount_CRMContactId_TCRMContact] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TClientBankAccount] ADD CONSTRAINT [FK_TClientBankAccount_CRMContactId2_TCRMContact] FOREIGN KEY ([CRMContactId2]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TClientBankAccount] ADD CONSTRAINT [FK_TClientBankAccount_RefCountryId_TRefCountry] FOREIGN KEY ([RefCountryId]) REFERENCES [dbo].[TRefCountry] ([RefCountryId])
GO
ALTER TABLE [dbo].[TClientBankAccount] ADD CONSTRAINT [FK_TClientBankAccount_RefCountyId_TRefCounty] FOREIGN KEY ([RefCountyId]) REFERENCES [dbo].[TRefCounty] ([RefCountyId])
GO
CREATE NONCLUSTERED INDEX [IDX_TClientBankAccount_CRMContactId] ON [dbo].[TClientBankAccount] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
