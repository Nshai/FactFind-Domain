CREATE TABLE [dbo].[TRefCaseStatus]
(
[RefCaseStatusId] [int] NOT NULL IDENTITY(1, 1),
[CaseStatusName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[DefaultFg] [bit] NOT NULL CONSTRAINT [DF_TRefCaseStatus_DefaultFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCaseStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCaseStatus] ADD CONSTRAINT [PK_TRefCaseStatus] PRIMARY KEY NONCLUSTERED  ([RefCaseStatusId]) WITH (FILLFACTOR=80)
GO
