CREATE TABLE [dbo].[TProjectReference]
(
[ProjectReferenceId] [int] NOT NULL IDENTITY(1, 1),
[ProjectReferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProjectReference_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProjectReference] ADD CONSTRAINT [PK_TProjectReference] PRIMARY KEY NONCLUSTERED  ([ProjectReferenceId]) WITH (FILLFACTOR=80)
GO
