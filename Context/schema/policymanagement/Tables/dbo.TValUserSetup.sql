CREATE TABLE [dbo].[TValUserSetup]
(
[ValUserSetupId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[UseValuationFundsFg] [bit] NOT NULL,
[UseValuationAssetsFg] [bit] NOT NULL CONSTRAINT [DF_TValUserSetup_UseValuationAssetssFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValUserSetup_ConcurrencyId] DEFAULT ((1)),
[ExcludeValuationFundsFromPriceFeedUpdatesFg] [bit] NOT NULL CONSTRAINT [DF_TValUserSetup_ExcludeValuationFundsFromPriceFeedUpdatesFg] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TValUserSetup] ADD CONSTRAINT [PK_TValUserSetup] PRIMARY KEY NONCLUSTERED  ([ValUserSetupId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IX_TValUserSetup_UserId ON [dbo].[TValUserSetup] ([UserId]) INCLUDE ([ExcludeValuationFundsFromPriceFeedUpdatesFg]) 
GO