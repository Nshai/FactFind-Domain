CREATE TABLE [dbo].[TAdviseFeeChargingType]
(
[AdviseFeeChargingTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefAdviseFeeChargingTypeId] [int] NOT NULL,
[TenantId] [int] NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAdviseFeeChargingType_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviseFeeChargingType_ConcurrencyId] DEFAULT ((1)),
[GroupId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAdviseFeeChargingType] ADD CONSTRAINT [PK_TAdviseFeeChargingType] PRIMARY KEY CLUSTERED  ([AdviseFeeChargingTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviseFeeChargingType_GroupId] ON [dbo].[TAdviseFeeChargingType] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviseFeeChargingType_TenantId] ON [dbo].[TAdviseFeeChargingType] ([TenantId])
GO
ALTER TABLE [dbo].[TAdviseFeeChargingType] ADD CONSTRAINT [FK_TAdviseFeeChargingType_TRefAdviseFeeChargingType] FOREIGN KEY ([RefAdviseFeeChargingTypeId]) REFERENCES [dbo].[TRefAdviseFeeChargingType] ([RefAdviseFeeChargingTypeId])
GO
