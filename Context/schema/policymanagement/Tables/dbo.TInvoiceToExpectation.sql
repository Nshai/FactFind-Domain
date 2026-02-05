CREATE TABLE [dbo].[TInvoiceToExpectation](
	[InvoiceToExpectationId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceId] [int] NOT NULL,
	[ExpectationId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TInvoiceToExpectation] ADD CONSTRAINT [PK_TInvoiceToExpectation_InvoiceToExpectationId] PRIMARY KEY CLUSTERED  ([InvoiceToExpectationId] ASC)
GO
ALTER TABLE [dbo].[TInvoiceToExpectation] ADD CONSTRAINT FK_TInvoiceToExpectation_InvoiceId FOREIGN KEY ([InvoiceId]) REFERENCES [dbo].[TInvoice]([InvoiceId]);
GO
CREATE NONCLUSTERED INDEX IX_TInvoiceToExpectation_InvoiceId ON [dbo].[TInvoiceToExpectation] ([InvoiceId]);
GO


