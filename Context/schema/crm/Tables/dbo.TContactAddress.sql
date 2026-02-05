CREATE TABLE [dbo].[TContactAddress]
(
[ContactAddressId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ContactId] [int] NOT NULL,
[AddressId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TContactAddress_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TContactAddress] ADD CONSTRAINT [PK_TContactAddress] PRIMARY KEY CLUSTERED  ([ContactAddressId]) WITH (FILLFACTOR=80)
GO
