CREATE TABLE [dbo].[TRefAddressStatus]
(
[RefAddressStatusId] [tinyint] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AddressStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAddressStatus] ADD CONSTRAINT [PK_TRefAddressStatus] PRIMARY KEY CLUSTERED  ([RefAddressStatusId])
GO
