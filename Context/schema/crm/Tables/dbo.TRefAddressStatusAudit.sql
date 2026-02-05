CREATE TABLE [dbo].[TRefAddressStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AddressStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RefAddressStatusId] [tinyint] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefAddressStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAddressStatusAudit] ADD CONSTRAINT [PK_TRefAddressStatusAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
