CREATE TABLE [dbo].[TRefDeferredPremiumLength]
(
[RefDeferredPremiumLengthId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefDeferredPremiumLength_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefDeferredPremiumLength] ADD CONSTRAINT [PK_TRefDeferredPremiumLength] PRIMARY KEY CLUSTERED  ([RefDeferredPremiumLengthId])
GO
