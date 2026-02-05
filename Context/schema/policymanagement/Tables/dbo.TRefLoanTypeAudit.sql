CREATE TABLE [dbo].[TRefLoanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LoanTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefLoanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefLoanTy_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefLoanTypeAudit] ADD CONSTRAINT [PK_TRefLoanTypeAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefLoanTypeAudit_RefLoanTypeId_ConcurrencyId] ON [dbo].[TRefLoanTypeAudit] ([RefLoanTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
