CREATE TABLE [dbo].[TRefSubjectAM]
(
[RefSubjectAMId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TRefSubjec_ArchiveFG_1__51] DEFAULT ((0)),
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefSubjec_ConcurrencyId_2__51] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefSubjectAM] ADD CONSTRAINT [PK_TRefSubjectAM_3__51] PRIMARY KEY NONCLUSTERED  ([RefSubjectAMId]) WITH (FILLFACTOR=80)
GO
