CREATE TABLE [dbo].[TProviderPlanTypeCode]
(
    [ProviderPlanTypeCodeId] int NOT NULL IDENTITY(1,1),
    [RefPlanType2ProdSubTypeId] int NOT NULL,
    [ProdProviderId] int NOT NULL,
    [Code] nvarchar(10) NOT NULL,
    [Abbreviation] nvarchar(50) NULL
)
GO
ALTER TABLE [dbo].[TProviderPlanTypeCode] 
ADD CONSTRAINT [PK_ProviderPlanTypeCode] PRIMARY KEY CLUSTERED ([ProviderPlanTypeCodeId])
GO