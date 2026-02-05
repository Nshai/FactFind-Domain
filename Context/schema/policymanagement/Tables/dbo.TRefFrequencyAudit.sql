CREATE TABLE [dbo].[TRefFrequencyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FrequencyName] [varchar] (50) NULL,
[OrigoRef] [varchar] (50) NULL,
[RetireFg] [tinyint] NULL,
[OrderNo] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefFrequencyId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefFrequencyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[MultiplierForAnnualisedAmount] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[TRefFrequencyAudit] ADD CONSTRAINT [PK_TRefFrequencyAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefFrequencyAudit_RefFrequencyId_ConcurrencyId] ON [dbo].[TRefFrequencyAudit] ([RefFrequencyId], [ConcurrencyId])
GO
