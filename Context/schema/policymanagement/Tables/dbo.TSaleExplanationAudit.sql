CREATE TABLE [dbo].[TSaleExplanationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TSaleExplanationAudit_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL,
[SaleExplanationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSaleExplanationAudit] ADD CONSTRAINT [PK_TSaleExplanationAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
