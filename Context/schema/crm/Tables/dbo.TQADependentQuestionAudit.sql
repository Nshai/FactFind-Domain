CREATE TABLE [dbo].[TQADependentQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ParentQuestionId] [int] NULL,
[QADropDownLinkId] [int] NULL,
[ChildQuestionId] [int] NULL,
[ArchiveFg] [bit] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[QADependentQuestionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQADepende_StampDateTime_1__60] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQADependentQuestionAudit] ADD CONSTRAINT [PK_TQADependentQuestionAudit_2__60] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TQADependentQuestionAudit_QADependentQuestionId_ConcurrencyId] ON [dbo].[TQADependentQuestionAudit] ([QADependentQuestionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
