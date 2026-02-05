CREATE TABLE [dbo].[TRiskAttitudeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[RiskCategoryId] [int] NULL,
[LowerBound] [int] NULL,
[UpperBound] [int] NULL,
[RiskRangeId] [int] NULL,
[Notes] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RiskAttitudeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRiskAttit_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRiskAttitudeAudit] ADD CONSTRAINT [PK_TRiskAttitudeAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRiskAttitudeAudit_RiskAttitudeId_ConcurrencyId] ON [dbo].[TRiskAttitudeAudit] ([RiskAttitudeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
