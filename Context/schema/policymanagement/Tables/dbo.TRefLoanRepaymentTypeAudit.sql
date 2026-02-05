CREATE TABLE [dbo].[TRefLoanRepaymentTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PaymentTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL CONSTRAINT [DF_TRefLoanRe_RetireFg_1__56] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefLoanRepaymentTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefLoanRe_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefLoanRepaymentTypeAudit] ADD CONSTRAINT [PK_TRefLoanRepaymentTypeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefLoanRepaymentTypeAudit_RefLoanRepaymentTypeId_ConcurrencyId] ON [dbo].[TRefLoanRepaymentTypeAudit] ([RefLoanRepaymentTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
