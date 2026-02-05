CREATE TABLE [dbo].[TRetainerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NetAmount] [money] NULL,
[VATAmount] [money] NULL,
[RefFeeRetainerFrequencyId] [int] NULL,
[StartDate] [datetime] NULL,
[ReviewDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[SentToClientDate] [datetime] NULL,
[ReceivedFromClientDate] [datetime] NULL,
[SentToBankDate] [datetime] NULL,
[Description] [varchar] (255) NULL,
[isVatExempt] [bit] NOT NULL CONSTRAINT [DF_TRetainerAudit_isVatExempt] DEFAULT ((0)),
[RefVATId] [int] NULL,
[SequentialRef] [varchar] (50) NULL,
[IndigoClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRetainerAudit_ConcurrencyId] DEFAULT ((1)),
[RetainerId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRetainerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TRetainerAudit] ADD CONSTRAINT [PK_TRetainerAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TRetainerAudit_RetainerId_ConcurrencyId] ON [dbo].[TRetainerAudit] ([RetainerId], [ConcurrencyId])
GO
