CREATE TABLE [dbo].[TRefPaymentBasisTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PaymentBasisTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefPaymentBasisTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPaymen_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPaymentBasisTypeAudit] ADD CONSTRAINT [PK_TRefPaymentBasisTypeAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefPaymentBasisTypeAudit_RefPaymentBasisTypeId_ConcurrencyId] ON [dbo].[TRefPaymentBasisTypeAudit] ([RefPaymentBasisTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
