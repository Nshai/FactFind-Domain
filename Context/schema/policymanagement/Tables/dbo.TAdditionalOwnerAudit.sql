CREATE TABLE [dbo].[TAdditionalOwnerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PolicyBusinessId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdditionalOwnerAudit_ConcurrencyId] DEFAULT ((1)),
[AdditionalOwnerId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdditionalOwnerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdditionalOwnerAudit] ADD CONSTRAINT [PK_TAdditionalOwnerAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAdditionalOwnerAudit_AdditionalOwnerId_ConcurrencyId] ON [dbo].[TAdditionalOwnerAudit] ([AdditionalOwnerId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
