CREATE TABLE [dbo].[TRefAdviseFeeChargingType]
(
[RefAdviseFeeChargingTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[IsUsedAsInitialFee] [bit] NOT NULL CONSTRAINT [DF_TRefAdviseFeeChargingType_UsedAsInitialFee] DEFAULT ((0)),
[IsUsedAsRecurringFee] [bit] NOT NULL CONSTRAINT [DF_TRefAdviseFeeChargingType_UsedAsRecurringFee] DEFAULT ((0)),
[IsUsedAsOneOffFee] [bit] NOT NULL CONSTRAINT [DF_TRefAdviseFeeChargingType_UsedAsOneOffFee] DEFAULT ((0)),
[IsPercentageBased] [bit] NOT NULL CONSTRAINT [DF_TRefAdviseFeeChargingType_IsPercentageBased] DEFAULT ((0)),
[IsTieredPercentage] [bit] NOT NULL CONSTRAINT [DF_TRefAdviseFeeChargingType_IsTieredPercentage] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefAdviseFeeChargingType] ADD CONSTRAINT [PK_TRefAdviseFeeChargingType] PRIMARY KEY CLUSTERED  ([RefAdviseFeeChargingTypeId])
GO

