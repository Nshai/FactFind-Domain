CREATE TABLE [dbo].[TAdviseCategoryToFeeModel]
(
[AdviseCategoryToFeeModelId] [int] NOT NULL IDENTITY(1, 1),
[AdviseCategoryId] [int] NOT NULL,
[FeeModelId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviseCategoryToFeeModel_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviseCategoryToFeeModel] ADD CONSTRAINT [PK_TAdviseCategoryToFeeModel] PRIMARY KEY CLUSTERED  ([AdviseCategoryToFeeModelId])
GO
