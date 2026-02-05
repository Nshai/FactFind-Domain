CREATE TABLE [dbo].[TVerificationHistoryAddress]
(
[VerificationHistoryAddressId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UserId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[AddressId] [int] NOT NULL,
[LookupDate] [datetime] NOT NULL CONSTRAINT [DF_TVerificationHistoryAddress_LookupDate] DEFAULT (getdate()),
[LookupResult] [bit] NOT NULL CONSTRAINT [DF_TVerificationHistoryAddress_LookupResult] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TVerificationHistoryAddress_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TVerificationHistoryAddress] ADD CONSTRAINT [PK_TVerificationHistoryAddress] PRIMARY KEY CLUSTERED  ([VerificationHistoryAddressId])
GO
