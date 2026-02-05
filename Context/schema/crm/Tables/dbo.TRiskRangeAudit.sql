CREATE TABLE [dbo].[TRiskRangeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RiskCategoryId] [int] NULL,
[LowerBound] [int] NOT NULL,
[UpperBound] [int] NOT NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RiskRangeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRiskRange_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRiskRangeAudit] ADD CONSTRAINT [PK_TRiskRangeAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRiskRangeAudit_RiskRangeId_ConcurrencyId] ON [dbo].[TRiskRangeAudit] ([RiskRangeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
