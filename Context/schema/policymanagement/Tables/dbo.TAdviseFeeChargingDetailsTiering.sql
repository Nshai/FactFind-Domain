CREATE TABLE [dbo].[TAdviseFeeChargingDetailsTiering]
(
[AdviseFeeChargingDetailsTieringId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AdviseFeeChargingDetailsId] [int] NOT NULL,
[Threshold] [decimal] (18, 2) NULL,
[Percentage] [decimal] (5, 2) NOT NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviseFeeChargingDetailsTiering_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviseFeeChargingDetailsTiering] ADD CONSTRAINT [PK_TAdviseFeeChargingDetailsTiering] PRIMARY KEY CLUSTERED  ([AdviseFeeChargingDetailsTieringId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdviseFeeChargingDetailsTiering_TenantId] ON [dbo].[TAdviseFeeChargingDetailsTiering] ([TenantId])
GO
ALTER TABLE [dbo].[TAdviseFeeChargingDetailsTiering] ADD CONSTRAINT [FK_TAdviseFeeChargingDetailsTiering_TAdviseFeeChargingDetails] FOREIGN KEY ([AdviseFeeChargingDetailsId]) REFERENCES [dbo].[TAdviseFeeChargingDetails] ([AdviseFeeChargingDetailsId])
GO
