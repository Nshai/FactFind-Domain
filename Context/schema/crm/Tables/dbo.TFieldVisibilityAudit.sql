CREATE TABLE [dbo].[TFieldVisibilityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Field] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[SectionDefinitionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FieldVisibilityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFieldVisibilityAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFieldVisibilityAudit] ADD CONSTRAINT [PK_TFieldVisibilityAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
