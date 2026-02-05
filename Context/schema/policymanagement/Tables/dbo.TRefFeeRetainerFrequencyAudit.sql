CREATE TABLE [dbo].[TRefFeeRetainerFrequencyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PeriodName] [varchar] (50) NULL,
[NumMonths] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefFeeRet_ConcurrencyId] DEFAULT ((1)),
[RefFeeRetainerFrequencyId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefFeeRet_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TRefFeeRetainerFrequencyAudit] ADD CONSTRAINT [PK_TRefFeeRetainerFrequencyAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefFeeRetainerFrequencyAudit_RefFeeRetainerFrequencyId_ConcurrencyId] ON [dbo].[TRefFeeRetainerFrequencyAudit] ([RefFeeRetainerFrequencyId], [ConcurrencyId])
GO
