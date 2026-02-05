CREATE TABLE [dbo].[TAccountTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AccountTypeId] [int] NOT NULL,
[AccountTypeName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[IsForCorporate] [bit] NULL,
[IsForIndividual] [bit] NULL,
[IsNotModifiable] [bit] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF__TAccountT__IsArc__2A9AF382] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAccountTypeAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAccountTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAccountTypeAudit] ADD CONSTRAINT [PK_TAccountTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAccountTypeAudit_AccountTypeId_ConcurrencyId] ON [dbo].[TAccountTypeAudit] ([AccountTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
