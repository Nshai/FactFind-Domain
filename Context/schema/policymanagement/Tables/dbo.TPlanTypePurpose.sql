CREATE TABLE [dbo].[TPlanTypePurpose]
(
[PlanTypePurposeId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanTypeId] [int] NULL,
[PlanPurposeId] [int] NOT NULL,
[DefaultFg] [bit] NULL CONSTRAINT [DF_TPlanTypePurpose_DefaultFg] DEFAULT ((0)),
[RefPlanType2ProdSubTypeId] [int] NOT NULL CONSTRAINT [DF_TPlanTypePurpose_RefPlanType2ProdSubTypeId]  DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanTypePurpose_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPlanTypePurpose] ADD CONSTRAINT [PK_TPlanTypePurpose] PRIMARY KEY NONCLUSTERED  ([PlanTypePurposeId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IDX_TPlanTypePurpose_PlanPurposeId] ON [dbo].[TPlanTypePurpose] ([PlanPurposeId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IDX_TPlanTypePurpose_RefPlanTypeId] ON [dbo].[TPlanTypePurpose] ([RefPlanTypeId]) WITH (FILLFACTOR=75)
GO
ALTER TABLE [dbo].[TPlanTypePurpose] ADD CONSTRAINT [FK_TPlanTypePurpose_PlanPurposeId_PlanPurposeId] FOREIGN KEY ([PlanPurposeId]) REFERENCES [dbo].[TPlanPurpose] ([PlanPurposeId])
GO
ALTER TABLE [dbo].[TPlanTypePurpose] ADD CONSTRAINT [FK_TPlanTypePurpose_RefPlanTypeId_RefPlanTypeId] FOREIGN KEY ([RefPlanTypeId]) REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId])
GO
