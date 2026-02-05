CREATE TABLE [dbo].[TRefServiceStatusToFeeModel]
(
[RefServiceStatusToFeeModelId] [int] NOT NULL IDENTITY(1, 1),
[RefServiceStatusId] [int] NOT NULL,
[FeeModelId] [int] NOT NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF_TRefServiceStatusToFeeModel_IsDefault] DEFAULT ((0)),
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefServiceStatusToFeeModel_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefServiceStatusToFeeModel] ADD CONSTRAINT [PK_TRefServiceStatusToFeeModel] PRIMARY KEY CLUSTERED  ([RefServiceStatusToFeeModelId])
GO
