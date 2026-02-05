CREATE TABLE [dbo].[TAdviseFeeChargingTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefAdviseFeeChargingTypeId] [int] NOT NULL,
[TenantId] [int] NULL,
[IsArchived] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AdviseFeeChargingTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[GroupId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAdviseFeeChargingTypeAudit] ADD CONSTRAINT [PK_TAdviseFeeChargingTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviseFeeChargingTypeAudit_AdviseFeeChargingTypeId] ON [dbo].[TAdviseFeeChargingTypeAudit] ([AdviseFeeChargingTypeId])
GO
