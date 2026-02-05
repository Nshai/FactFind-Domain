CREATE TABLE [dbo].[TAccountAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AccountId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[AccountTypeId] [int] NULL,
[RefAccountAccessId] [int] NULL,
[RefProductProviderId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[CreatedBy] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAccountAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAccountAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAccountAudit] ADD CONSTRAINT [PK_TAccountAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAccountAudit_AccountId_ConcurrencyId] ON [dbo].[TAccountAudit] ([AccountId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
