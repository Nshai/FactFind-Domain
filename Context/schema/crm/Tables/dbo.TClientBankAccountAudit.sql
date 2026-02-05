CREATE TABLE [dbo].[TClientBankAccountAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
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
[DefaultAccountFg] [bit] NOT NULL CONSTRAINT [DF_TClientBankAccountAudit_DefaultAccountFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientBankAccountAudit_ConcurrencyId] DEFAULT ((1)),
[ClientBankAccountId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientBankAccountAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientBankAccountAudit] ADD CONSTRAINT [PK_TClientBankAccountAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TClientBankAccountAudit_ClientBankAccountId_ConcurrencyId] ON [dbo].[TClientBankAccountAudit] ([ClientBankAccountId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
