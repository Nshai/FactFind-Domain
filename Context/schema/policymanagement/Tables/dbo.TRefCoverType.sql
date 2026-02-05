CREATE TABLE [dbo].[TRefCoverType]
(
[RefCoverTypeId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (25) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefCoverType] ADD CONSTRAINT [PK_TRefCoverType] PRIMARY KEY CLUSTERED  ([RefCoverTypeId])
GO
