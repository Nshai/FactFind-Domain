CREATE TABLE [dbo].[TClientResearchData]
(
[ClientResearchDataId] [int] NOT NULL IDENTITY(1, 1),
[ClientResearchId] [int] NOT NULL,
[Data] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientResearchData_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TClientResearchData] ADD CONSTRAINT [PK_TClientResearchData] PRIMARY KEY CLUSTERED  ([ClientResearchDataId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TClientResearchData_ClientResearchIdASC] ON [dbo].[TClientResearchData] ([ClientResearchId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TClientResearchData] ADD CONSTRAINT [FK_TClientResearchData_ClientResearchId_ClientResearchId] FOREIGN KEY ([ClientResearchId]) REFERENCES [dbo].[TClientResearch] ([ClientResearchId])
GO
