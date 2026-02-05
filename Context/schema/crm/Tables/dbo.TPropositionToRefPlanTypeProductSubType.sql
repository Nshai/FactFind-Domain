Create TABLE [dbo].[TPropositionToRefPlanTypeProductSubType]
(
[PropositionToRefPlanTypeProductSubTypeId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[PropositionTypeId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPropositionToRefPlanTypeProductSubType_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPropositionToRefPlanTypeProductSubType_TenantId_RefPlanType2ProdSubTypeId] ON [dbo].[TPropositionToRefPlanTypeProductSubType] ([TenantId], [RefPlanType2ProdSubTypeId])
GO
ALTER TABLE [dbo].[TPropositionToRefPlanTypeProductSubType] ADD CONSTRAINT [PK_TPropositionToRefPlanTypeProductSubType] PRIMARY KEY CLUSTERED  ([PropositionToRefPlanTypeProductSubTypeId])
GO