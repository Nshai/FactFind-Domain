CREATE TABLE [dbo].[TValScheduleFileDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[FilePath] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FileNamePattern] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FieldNames] [varchar] (2000) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValScheduleFileDetailAudit_ConcurrencyId] DEFAULT ((1)),
[ValScheduleFileDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValScheduleFileDetailAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValScheduleFileDetailAudit] ADD CONSTRAINT [PK_TValScheduleFileDetailAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TValScheduleFileDetailAudit_ValScheduleFileDetailId_ConcurrencyId] ON [dbo].[TValScheduleFileDetailAudit] ([ValScheduleFileDetailId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
