CREATE TABLE [dbo].[TDpGuidTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDpGuidTypeAudit_ConcurrencyId] DEFAULT ((1)),
[DpGuidTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDpGuidTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDpGuidTypeAudit] ADD CONSTRAINT [PK_TDpGuidTypeAudit] PRIMARY KEY NONCLUSTERED  ([DpGuidTypeId]) WITH (FILLFACTOR=80)
GO
