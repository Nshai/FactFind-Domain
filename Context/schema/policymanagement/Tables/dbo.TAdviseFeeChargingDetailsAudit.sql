CREATE TABLE [dbo].[TAdviseFeeChargingDetailsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AdviseFeeChargingTypeId] [int] NOT NULL,
[Amount] [decimal] (18, 2) NULL,
[PercentageOfFee] [decimal] (5, 2) NULL,
[MinimumFee] [decimal] (15, 2) NULL,
[MaximumFee] [decimal] (15, 2) NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[AdviseFeeChargingDetailsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAdviseFeeChargingDetailsAudit_IsArchived] DEFAULT ((0)),
[GroupId] [int] NULL,
[MinimumFeePercentage] [decimal] (5, 2) NULL,
[MaximumFeePercentage] [decimal] (5, 2) NULL,
[IsSystemDefined] [bit] NULL,
[Name] [nvarchar] (128) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviseFeeChargingDetailsAudit] ADD CONSTRAINT [PK_TAdviseFeeChargingDetailsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
