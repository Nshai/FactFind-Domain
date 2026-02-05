CREATE TABLE [dbo].[TRefTrustType]
(
[RefTrustTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TrustTypeName] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [tinyint] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTrustT_ConcurrencyId_1__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTrustType] ADD CONSTRAINT [PK_TRefTrustType_2__54] PRIMARY KEY NONCLUSTERED  ([RefTrustTypeId]) WITH (FILLFACTOR=80)
GO
