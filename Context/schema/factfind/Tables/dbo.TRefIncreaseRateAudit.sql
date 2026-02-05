CREATE TABLE [dbo].[TRefIncreaseRateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefIncreaseRateId] [int] NOT NULL,
[IncreaseRateType] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [smallint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefIncreaseRateAudit_ConcurrencyId] DEFAULT ((0)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefIncreaseRateAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefIncreaseRateAudit] ADD CONSTRAINT [PK_TRefIncreaseRateAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
