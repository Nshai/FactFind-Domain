CREATE TABLE [dbo].[TRefCaseType]
(
[RefCaseTypeId] [int] NOT NULL IDENTITY(1, 1),
[CaseTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCaseType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCaseType] ADD CONSTRAINT [PK_TRefCaseType] PRIMARY KEY NONCLUSTERED  ([RefCaseTypeId]) WITH (FILLFACTOR=80)
GO
