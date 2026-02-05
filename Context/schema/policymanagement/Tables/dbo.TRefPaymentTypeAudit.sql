CREATE TABLE [dbo].[TRefPaymentTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPaymentTypeId] [int] NOT NULL,
[RefPaymentTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefPaymentTypeAudit] ADD CONSTRAINT [PK_TRefPaymentTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
