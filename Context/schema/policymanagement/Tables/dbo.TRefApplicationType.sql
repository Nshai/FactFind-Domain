CREATE TABLE [dbo].[TRefApplicationType]
(
[RefApplicationTypeId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefApplicationType_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefApplicationType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefApplicationType] ADD CONSTRAINT [PK_TRefApplicationType] PRIMARY KEY NONCLUSTERED  ([RefApplicationTypeId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TRefApplicationType] ON [dbo].[TRefApplicationType] ([RefApplicationTypeId]) WITH (FILLFACTOR=80)
GO
