CREATE TABLE [dbo].[TRefCaseReason]
(
[RefCaseReasonId] [int] NOT NULL IDENTITY(1, 1),
[CaseReasonName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCaseReason_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefCaseReason] ADD CONSTRAINT [PK_TRefCaseReason] PRIMARY KEY NONCLUSTERED  ([RefCaseReasonId]) WITH (FILLFACTOR=80)
GO
