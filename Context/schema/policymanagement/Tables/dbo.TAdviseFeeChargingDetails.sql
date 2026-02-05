CREATE TABLE [dbo].[TAdviseFeeChargingDetails]
(
[AdviseFeeChargingDetailsId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AdviseFeeChargingTypeId] [int] NOT NULL,
[Amount] [decimal] (18, 2) NULL,
[PercentageOfFee] [decimal] (5, 2) NULL,
[MinimumFee] [decimal] (15, 2) NULL,
[MaximumFee] [decimal] (15, 2) NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviseFeeChargingDetails_ConcurrencyId] DEFAULT ((1)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAdviseFeeChargingDetails_IsArchived] DEFAULT ((0)),
[GroupId] [int] NULL,
[MinimumFeePercentage] [decimal] (5, 2) NULL,
[MaximumFeePercentage] [decimal] (5, 2) NULL,
[IsSystemDefined] [bit] NOT NULL CONSTRAINT [DF_TAdviseFeeChargingDetails_IsSystemDefined] DEFAULT ((0)),
[Name] [nvarchar] (128) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviseFeeChargingDetails] ADD CONSTRAINT [PK_TAdviseFeeChargingDetails] PRIMARY KEY CLUSTERED  ([AdviseFeeChargingDetailsId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviseFeeChargingDetails_GroupId] ON [dbo].[TAdviseFeeChargingDetails] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviseFeeChargingDetails_TenantId] ON [dbo].[TAdviseFeeChargingDetails] ([TenantId])
GO
ALTER TABLE [dbo].[TAdviseFeeChargingDetails] ADD CONSTRAINT [FK_TAdviseFeeChargingDetails_TAdviseFeeChargingType] FOREIGN KEY ([AdviseFeeChargingTypeId]) REFERENCES [dbo].[TAdviseFeeChargingType] ([AdviseFeeChargingTypeId])
GO
