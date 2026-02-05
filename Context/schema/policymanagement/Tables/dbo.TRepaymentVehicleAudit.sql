CREATE TABLE [dbo].[TRepaymentVehicleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[MortgageId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RepaymentVehicleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRepaymentVehicleAudit] ADD CONSTRAINT [PK_TRepaymentVehicleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
