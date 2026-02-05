CREATE TABLE [dbo].[TCorporateOperationalAddress]
(
[CorporateOperationalAddressId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[isSameAsRegistered] [bit] NULL,
[ContactId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCorporateOperationalAddress_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateOperationalAddress_CRMContactId] ON [dbo].[TCorporateOperationalAddress] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
