CREATE TABLE [dbo].[TInvoiceToFeeAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[InvoiceId] [int] NOT NULL,
	[FeeId] [int] NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[InvoiceToFeeId] [int] NOT NULL,
	[StampAction] [char] (1) NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_Tmp_TInvoiceToFeeAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255),
	[NetAmount] [money] NULL,
	[VATAmount] [money] NULL
)
GO
ALTER TABLE [dbo].[TInvoiceToFeeAudit] ADD CONSTRAINT [PK_TInvoiceToFeeAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId])
GO
