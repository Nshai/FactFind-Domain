CREATE TABLE [dbo].[TIndigoClientCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Guid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[RefEnvironmentId] [int] NOT NULL,
[IsPortfolioConstructionProvider] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientCombinedAudit_IsPortfolioConstructionProvider] DEFAULT ((0)),
[IsAuthorProvider] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientCombinedAudit_IsAuthorProvider] DEFAULT ((0)),
[IsAtrProvider] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientCombinedAudit_IsAtrProvider] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIndigoClientCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientCombinedAudit] ADD CONSTRAINT [PK_TIndigoClientCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
