CREATE TABLE [dbo].[TIndigoClientAdviceCaseStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AdviceCaseStatusId] [int] NOT NULL,
[isArchived] [bit] NOT NULL CONSTRAINT [DF_TIndigoClientAdviceCaseStatusAudit_isArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClientAdviceCaseStatusAudit_ConcurrencyId] DEFAULT ((1)),
[IndigoClientAdviceCaseStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIndigoClientAdviceCaseStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndigoClientAdviceCaseStatusAudit] ADD CONSTRAINT [PK_TIndigoClientAdviceCaseStatusAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIndigoClientAdviceCaseStatusAudit_IndigoClientAdviceCaseStatusId_ConcurrencyId] ON [dbo].[TIndigoClientAdviceCaseStatusAudit] ([IndigoClientAdviceCaseStatusId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
