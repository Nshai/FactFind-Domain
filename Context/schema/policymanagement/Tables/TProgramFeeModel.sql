CREATE TABLE [dbo].[TProgramFeeModel]
(
[ProgramFeeModelId] [int] NOT NULL IDENTITY(1, 1),
[ProgramId] [int] NOT NULL,
[FeeModelId] [int] NOT NULL,
)
GO

ALTER TABLE [dbo].[TProgramFeeModel] ADD CONSTRAINT [PK_TProgramFeeModel_ProgramFeeModelId] PRIMARY KEY NONCLUSTERED  ([ProgramFeeModelId])
GO

CREATE NONCLUSTERED INDEX [IDX_TProgramFeeModel] ON [dbo].[TProgramFeeModel] ([FeeModelId])
GO

ALTER TABLE [dbo].[TProgramFeeModel] ADD CONSTRAINT [FK_TProgramFeeModel_FeeModelId_FeeModelId] FOREIGN KEY ([FeeModelId]) REFERENCES [dbo].[TFeeModel] ([FeeModelId])
GO

ALTER TABLE [dbo].[TProgramFeeModel] ADD CONSTRAINT [FK_TProgramFeeModel_ProgramId_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[TProgram] ([ProgramId])
GO

ALTER TABLE [dbo].[TProgramFeeModel] ADD CONSTRAINT [UQ_TProgramFeeModel_ProgramId_FeeModelId] UNIQUE ([ProgramId],[FeeModelId])
GO
