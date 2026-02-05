CREATE TABLE [dbo].[TServiceLevelAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ContractHostFg] [bit] NOT NULL CONSTRAINT [DF_TServiceLevelAudit_ContractHostFg] DEFAULT ((0)),
[UseNetworkAuthorDocs] [bit] NOT NULL CONSTRAINT [DF_TServiceLevelAudit_UseNetworkAuthorDocs] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TServiceLevelAudit_ConcurrencyId] DEFAULT ((1)),
[ServiceLevelId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TServiceLevelAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TServiceLevelAudit] ADD CONSTRAINT [PK_TServiceLevelAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
