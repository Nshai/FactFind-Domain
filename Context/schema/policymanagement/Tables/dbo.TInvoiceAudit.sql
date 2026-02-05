CREATE TABLE [dbo].[TInvoiceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Description] [varchar] (1000) NULL,
[DocVersionId] [int] NULL,
[ExternalReference] [varchar] (50) NULL,
[SequentialRef] [varchar] (50) NULL,
[InvoiceDate] [datetime] NULL,
[CreatedDate] [datetime] NULL,
[SentToClientDate] [datetime] NULL,
[NetAmount] [money] NULL,
[VATAmount] [money] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[InvoiceId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_Tmp_TInvoiceAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TInvoiceAudit] ADD CONSTRAINT [PK_TInvoiceAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId])
GO
