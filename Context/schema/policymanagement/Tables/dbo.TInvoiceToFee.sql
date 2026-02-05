CREATE TABLE [dbo].[TInvoiceToFee](
	[InvoiceToFeeId] [int] NOT NULL IDENTITY(1, 1),
	[InvoiceId] [int] NOT NULL,
	[FeeId] [int] NOT NULL,
	[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInvoiceToFee_ConcurrencyId] DEFAULT ((1)),
	[NetAmount] [money] NULL,
	[VATAmount] [money] NULL
)
GO
ALTER TABLE [dbo].[TInvoiceToFee] ADD CONSTRAINT [PK_TInvoiceToFee_InvoiceToFeeId] PRIMARY KEY CLUSTERED  ([InvoiceToFeeId])
GO
CREATE NONCLUSTERED INDEX IX_TInvoiceToFee_FeeID ON [dbo].[TInvoiceToFee] ([FeeId]) INCLUDE ([InvoiceId])
GO


