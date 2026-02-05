CREATE TABLE [dbo].[TFeeRetainerVATAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NULL,
[RetainerId] [int] NULL,
[RefVATId] [int] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFeeRetainerVATAudit_ConcurrencyId] DEFAULT ((1)),
[FeeRetainerVATId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFeeRetainerVATAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeRetainerVATAudit] ADD CONSTRAINT [PK_TFeeRetainerVATAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFeeRetainerVATAudit_FeeRetainerVATId_ConcurrencyId] ON [dbo].[TFeeRetainerVATAudit] ([FeeRetainerVATId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
