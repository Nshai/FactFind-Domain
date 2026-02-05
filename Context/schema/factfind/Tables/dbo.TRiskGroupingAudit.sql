CREATE TABLE [dbo].[TRiskGroupingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Tolerance] [int] NULL,
[IsArchived] [bit] NULL,
[IndigoClientId] [int] NOT NULL,
[RiskGroupingId] [int] NULL,
[RiskGroupingSyncId] [varchar] (50) CONSTRAINT [DF_TRiskGroupingAudit_RiskGroupingSyncId] DEFAULT(NULL),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRiskGroupingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRiskGroupingAudit] ADD CONSTRAINT [PK_TRiskGroupingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
