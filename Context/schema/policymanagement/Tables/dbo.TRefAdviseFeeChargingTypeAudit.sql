CREATE TABLE [dbo].[TRefAdviseFeeChargingTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefAdviseFeeChargingTypeId] [int] NOT NULL,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[IsUsedAsInitialFee] [bit] NOT NULL,
[IsUsedAsRecurringFee] [bit] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsPercentageBased] [bit] NULL,
[IsTieredPercentage] [bit] NULL,
[IsUsedAsOneOffFee] [bit] NULL
)
GO
ALTER TABLE [dbo].[TRefAdviseFeeChargingTypeAudit] ADD CONSTRAINT [PK_TRefAdviseFeeChargingTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
