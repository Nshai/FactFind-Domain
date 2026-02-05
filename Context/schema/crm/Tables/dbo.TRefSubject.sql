CREATE TABLE [dbo].[TRefSubject]
(
[RefSubjectId] [int] NOT NULL IDENTITY(1, 1),
[Subject] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefSubjec_ConcurrencyId_1__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefSubject] ADD CONSTRAINT [PK_TRefSubject_2__54] PRIMARY KEY NONCLUSTERED  ([RefSubjectId]) WITH (FILLFACTOR=80)
GO
