CREATE TABLE [dbo].[TRefCaseEnvironment]
(
[RefCaseEnvironmentId] [int] NOT NULL IDENTITY(1, 1),
[CaseEnvironmentName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCaseEnvironment_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCaseEnvironment] ADD CONSTRAINT [PK_TRefCaseEnvironment] PRIMARY KEY NONCLUSTERED  ([RefCaseEnvironmentId]) WITH (FILLFACTOR=80)
GO
