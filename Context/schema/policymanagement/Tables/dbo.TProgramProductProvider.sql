CREATE TABLE [dbo].[TProgramProductProvider]
(
[ProgramProductProviderId] [int] NOT NULL IDENTITY(1, 1),
[ProgramId] [int] NOT NULL,
[ProviderId] [int] NOT NULL,
)
GO

ALTER TABLE [dbo].[TProgramProductProvider] ADD CONSTRAINT [PK_TProgramProductProvider_ProgramProductProviderId] PRIMARY KEY NONCLUSTERED ([ProgramProductProviderId])
GO

CREATE NONCLUSTERED INDEX [IDX_TProgramProductProvider] ON [dbo].[TProgramProductProvider] ([ProviderId])
GO

ALTER TABLE [dbo].[TProgramProductProvider] ADD CONSTRAINT [FK_TProgramProductProvider_ProgramId_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[TProgram] ([ProgramId])
GO

ALTER TABLE [dbo].[TProgramProductProvider] ADD CONSTRAINT [UQ_TProgramProductProvider_ProgramId_ProviderId] UNIQUE ([ProgramId],[ProviderId])
GO