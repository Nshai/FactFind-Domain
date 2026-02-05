CREATE TABLE [dbo].[TTaxConsequenceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TTaxConsequenceAudit_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL,
[TaxConsequenceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTaxConsequenceAudit] ADD CONSTRAINT [PK_TTaxConsequenceAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
