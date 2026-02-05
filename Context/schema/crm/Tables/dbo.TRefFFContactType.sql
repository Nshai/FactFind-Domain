CREATE TABLE [dbo].[TRefFFContactType]
(
[RefFFContactTypeId] [int] NOT NULL IDENTITY(1, 1),
[ContactTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ValidationExpression] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TRefFFContactType_ArchiveFG] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFFContactType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFFContactType] ADD CONSTRAINT [PK_TRefFFContactType] PRIMARY KEY CLUSTERED  ([RefFFContactTypeId]) WITH (FILLFACTOR=80)
GO
