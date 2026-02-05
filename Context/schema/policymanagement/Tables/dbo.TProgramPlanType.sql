CREATE TABLE [dbo].[TProgramPlanType]
(
[ProgramPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[ProgramId] [int] NOT NULL,
[PlanTypeId] [int] NOT NULL,
)
GO
ALTER TABLE [dbo].[TProgramPlanType] ADD CONSTRAINT [PK_TProgramPlanType_ProgramPlanTypeId] PRIMARY KEY NONCLUSTERED ([ProgramPlanTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProgramPlanType] ON [dbo].[TProgramPlanType] ([PlanTypeId])
GO
ALTER TABLE [dbo].[TProgramPlanType] ADD CONSTRAINT [FK_TProgramPlanType_PlanTypeId_RefPlanType2ProdSubTypeId] FOREIGN KEY ([PlanTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
ALTER TABLE [dbo].[TProgramPlanType] ADD CONSTRAINT [FK_TProgramPlanType_ProgramId_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[TProgram] ([ProgramId])
GO
ALTER TABLE [dbo].[TProgramPlanType] ADD CONSTRAINT [UQ_TProgramPlanType_ProgramId_PlanTypeId] UNIQUE ([ProgramId],[PlanTypeId])
GO