CREATE TABLE [dbo].[TRefQualificationPeriodAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QualificationPeriod] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RefQualificationPeriodId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefQualificationPeriodAudit_ConcurrencyId] DEFAULT ((0)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefQualificationPeriodAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefQualificationPeriodAudit] ADD CONSTRAINT [PK_TRefQualificationPeriodAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
