CREATE TABLE [dbo].[TRefCorporateType]
(
[RefCorporateTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TypeName] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[HasCompanyRegFg] [tinyint] NULL,
[ArchiveFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCorpor_ConcurrencyId_1__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCorporateType] ADD CONSTRAINT [PK_TRefCorporateType_2__54] PRIMARY KEY NONCLUSTERED  ([RefCorporateTypeId]) WITH (FILLFACTOR=80)
GO
