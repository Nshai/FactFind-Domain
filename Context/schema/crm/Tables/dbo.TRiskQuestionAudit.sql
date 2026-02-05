CREATE TABLE [dbo].[TRiskQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Question] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RiskQuestionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRiskQuest_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRiskQuestionAudit] ADD CONSTRAINT [PK_TRiskQuestionAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRiskQuestionAudit_RiskQuestionId_ConcurrencyId] ON [dbo].[TRiskQuestionAudit] ([RiskQuestionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
