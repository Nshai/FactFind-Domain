CREATE TABLE [dbo].[TInvoice]
(
[InvoiceId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Description] [varchar] (1000) NULL,
[DocVersionId] [int] NULL,
[ExternalReference] [varchar] (50) NULL,
[SequentialRefLegacy] [varchar] (50) NULL,
[SequentialRef]  AS (case when [SequentialRefLegacy] IS NULL then 'IOI'+right(replicate('0',(8))+CONVERT([varchar],[InvoiceId]),(8)) else [SequentialRefLegacy] end),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TInvoice_CreatedDate] DEFAULT (getdate()),
[SentToClientDate] [datetime] NULL,
[InvoiceDate] [datetime] NULL,
[NetAmount] [money] NULL,
[VATAmount] [money] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInvoice_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TInvoice] ADD CONSTRAINT [PK_TInvoice_InvoiceId] PRIMARY KEY CLUSTERED  ([InvoiceId])
GO
create index IX_Tinvoice_InoviceID on TInvoice(InvoiceId) 
go