CREATE TABLE [dbo].[TContactAddressAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ContactId] [int] NOT NULL,
[AddressId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TContactAddressAudit_ConcurrencyId] DEFAULT ((1)),
[ContactAddressId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TContactAddressAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TContactAddressAudit] ADD CONSTRAINT [PK_TContactAddressAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
