CREATE TABLE [dbo].[TFundSuperSector]
(
[FundSuperSectorId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TFundSuperSector_IsArchived] DEFAULT ((0)),
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundSuperSector_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFundSuperSector] ADD CONSTRAINT [PK_TFundSuperSector] PRIMARY KEY CLUSTERED  ([FundSuperSectorId])
GO
