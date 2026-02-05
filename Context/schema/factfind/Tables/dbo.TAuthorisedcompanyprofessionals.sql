CREATE TABLE [dbo].[TAuthorisedcompanyprofessionals]
(
[AuthorisedcompanyprofessionalsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Position] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAuthoris__Concu__38A457AD] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TAuthorisedcompanyprofessionals_CRMContactId] ON [dbo].[TAuthorisedcompanyprofessionals] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
