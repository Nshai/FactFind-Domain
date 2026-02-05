CREATE TABLE [dbo].[TRefPaymentBasisAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPaymentBasisName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefPaymentBasisId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPaymentBasisAudit] ADD CONSTRAINT [PK_TRefPaymentBasisAudi] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
