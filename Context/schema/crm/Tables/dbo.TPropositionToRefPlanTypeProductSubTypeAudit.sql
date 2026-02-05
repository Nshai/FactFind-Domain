CREATE TABLE [dbo].[TPropositionToRefPlanTypeProductSubTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[PropositionToRefPlanTypeProductSubTypeId] [int] NOT NULL,
[PropositionTypeId] [int] NULL,
[RefPlanType2ProdSubTypeId] [int] NULL,
[ConcurrencyId] [int] null,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPropositionToRefPlanTypeProductSubTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPropositionToRefPlanTypeProductSubTypeAudit] ADD CONSTRAINT [PK_TPropositionToRefPlanTypeProductSubTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPropositionToRefPlanTypeProductSubTypeAudit_PropositionToRefPlanTypeProductSubTypeId_ConcurrencyId] ON 
	[dbo].[TPropositionToRefPlanTypeProductSubTypeAudit] ([PropositionToRefPlanTypeProductSubTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO


