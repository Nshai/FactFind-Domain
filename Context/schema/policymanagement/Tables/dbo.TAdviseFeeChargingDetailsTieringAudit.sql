CREATE TABLE [dbo].[TAdviseFeeChargingDetailsTieringAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AdviseFeeChargingDetailsTieringId] [int] NOT NULL,
[AdviseFeeChargingDetailsId] [int] NOT NULL,
[Threshold] [decimal] (18, 2) NULL,
[Percentage] [decimal] (5, 2) NOT NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviseFeeChargingDetailsTieringAudit] ADD CONSTRAINT [PK_TAdviseFeeChargingDetailsTieringAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
