CREATE TABLE [dbo].[TValGatingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ImplementationCode] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[RefProdProviderId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[ProdSubTypeId] [int] NULL,
[OrigoProductType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OrigoProductVersion] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ValuationXSLId] [int] NULL,
[ProviderPlanTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValGatingAudit_ConcurrencyId] DEFAULT ((1)),
[ValGatingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValGatingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValGatingAudit] ADD CONSTRAINT [PK_TValGatingAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
