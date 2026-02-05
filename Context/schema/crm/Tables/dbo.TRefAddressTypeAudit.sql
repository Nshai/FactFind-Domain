CREATE TABLE [dbo].[TRefAddressTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AddressTypeName] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAddressTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefAddressTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefAddressTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAddressTypeAudit] ADD CONSTRAINT [PK_TRefAddressTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefAddressTypeAudit_RefAddressTypeId_ConcurrencyId] ON [dbo].[TRefAddressTypeAudit] ([RefAddressTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
