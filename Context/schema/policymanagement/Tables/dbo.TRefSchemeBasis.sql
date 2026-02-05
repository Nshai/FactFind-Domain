CREATE TABLE [dbo].[TRefSchemeBasis]
(
[RefSchemeBasisId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL,
[DPMapping] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefSchemeBasis] ADD CONSTRAINT [PK_TRefSchemeBasis] PRIMARY KEY CLUSTERED  ([RefSchemeBasisId])
GO
