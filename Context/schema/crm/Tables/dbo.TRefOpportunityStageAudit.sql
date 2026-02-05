CREATE TABLE [dbo].[TRefOpportunityStageAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Probability] [tinyint] NULL,
[OpenFG] [bit] NULL,
[ClosedFG] [bit] NULL,
[WonFG] [bit] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefOpportunityStageId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefOpport_StampDateTime_1__77] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefOpportunityStageAudit] ADD CONSTRAINT [PK_TRefOpportunityStageAudit_2__77] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefOpportunityStageAudit_RefOpportunityStageId_ConcurrencyId] ON [dbo].[TRefOpportunityStageAudit] ([RefOpportunityStageId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
