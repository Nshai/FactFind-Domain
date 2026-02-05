CREATE TABLE [dbo].[TTaxConsequenceCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TaxConsequenceId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TTaxConsequenceCombinedAudit_Guid] DEFAULT (newid()),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTaxConsequenceCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTaxConsequenceCombinedAudit] ADD CONSTRAINT [PK_TTaxConsequenceCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TTaxConsequenceCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TTaxConsequenceCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
