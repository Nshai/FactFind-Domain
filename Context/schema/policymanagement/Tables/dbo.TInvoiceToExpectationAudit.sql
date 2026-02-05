CREATE TABLE [dbo].[TInvoiceToExpectationAudit]
(
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceId] [int] NOT NULL,
	[ExpectationID] [int] NOT NULL,
	[InvoiceToExpectationId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_Tmp_TInvoiceToExpectationAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar](255) NULL,
)
GO
ALTER TABLE [dbo].[TInvoiceToExpectationAudit] ADD CONSTRAINT [PK_TInvoiceToExpectationAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId] ASC)
GO
