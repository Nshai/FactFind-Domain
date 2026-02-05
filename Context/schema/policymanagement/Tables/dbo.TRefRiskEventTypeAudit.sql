CREATE TABLE [dbo].[TRefRiskEventTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RiskEventTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ContactAssuredFg] [tinyint] NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefRiskEventTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefRiskEv_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefRiskEventTypeAudit] ADD CONSTRAINT [PK_TRefRiskEventTypeAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefRiskEventTypeAudit_RefRiskEventTypeId_ConcurrencyId] ON [dbo].[TRefRiskEventTypeAudit] ([RefRiskEventTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
