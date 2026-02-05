CREATE TABLE [dbo].[TRefAnnuityPaymentTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefAnnuityPaymentTypeId] [int] NOT NULL,
[RefAnnuityPaymentTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [int] NULL
)
GO
