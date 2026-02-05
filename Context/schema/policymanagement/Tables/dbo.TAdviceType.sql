CREATE TABLE [dbo].[TAdviceType]
(
[AdviceTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IntelligentOfficeAdviceType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TRefAdviceType_ArchiveFg] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAdvice_ConcurrencyId_1__87] DEFAULT ((1)),
[IsSystem] [bit] NOT NULL CONSTRAINT [DF_TAdviceType_IsSystem] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TAdviceType] ADD CONSTRAINT [PK_TRefAdviceType_2__87] PRIMARY KEY NONCLUSTERED  ([AdviceTypeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TAdviceType] ON [dbo].[TAdviceType] ([IndigoClientId], [AdviceTypeId], [Description]) WITH (FILLFACTOR=80)
GO
