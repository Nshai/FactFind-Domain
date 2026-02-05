CREATE TABLE [dbo].[TSupportWhiteIPAddress]
(
[SupportWhiteIPAddressId] [bigint] NOT NULL IDENTITY(1, 1),
[IPAddressRangeStart] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[IPAddressRangeEnd] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSupportWhiteIPAddress_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSupportWhiteIPAddress] ADD CONSTRAINT [PK_TSupportWhiteIPAddress] PRIMARY KEY CLUSTERED  ([SupportWhiteIPAddressId])
GO
