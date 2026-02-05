CREATE TABLE [dbo].[TClientResearchDataAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ClientResearchId] [int] NOT NULL,
[Data] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientResearchDataAudit_ConcurrencyId] DEFAULT ((1)),
[ClientResearchDataId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientResearchDataAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientResearchDataAudit] ADD CONSTRAINT [PK_TClientResearchDataAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
