CREATE TABLE [dbo].[TSaleExplanationCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SaleExplanationId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSaleExplanationCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TSaleExplanationCombinedAudit_Guid] DEFAULT (newid()),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSaleExplanationCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSaleExplanationCombinedAudit] ADD CONSTRAINT [PK_TSaleExplanationCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TSaleExplanationCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TSaleExplanationCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
