CREATE TABLE [dbo].[TRefPeriodTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PeriodTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPeriodTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefPeriodTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPeriodTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPeriodTypeAudit] ADD CONSTRAINT [PK_TRefPeriodTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
