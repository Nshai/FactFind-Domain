CREATE TABLE [dbo].[TRefCommissionTypeToPaymentDueTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefCommissionTypeId] [int] NOT NULL,
[RefPaymentDueTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefCommissionTypeToPaymentDueTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TRefCommissionTypeToPaymentDueTypeAudit] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCommissionTypeToPaymentDueTypeAudit] ADD CONSTRAINT [PK_TRefCommissionTypeToPaymentDueTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
