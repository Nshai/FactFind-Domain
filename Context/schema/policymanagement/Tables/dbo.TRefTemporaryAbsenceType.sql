CREATE TABLE [dbo].[TRefTemporaryAbsenceType]
(
[RefTemporaryAbsenceTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTemporaryAbsenceType] ADD CONSTRAINT [PK_TRefTemporaryAbsenceType] PRIMARY KEY CLUSTERED  ([RefTemporaryAbsenceTypeId])
GO
