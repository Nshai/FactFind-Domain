CREATE TABLE [dbo].[TQVTStageAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Stage] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Extensible] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL,
[QVTStageId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQVTStageA_StampDateTime_1__103] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQVTStageAudit] ADD CONSTRAINT [PK_TQVTStageAudit_2__103] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TQVTStageAudit_QVTStageId_ConcurrencyId] ON [dbo].[TQVTStageAudit] ([QVTStageId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
