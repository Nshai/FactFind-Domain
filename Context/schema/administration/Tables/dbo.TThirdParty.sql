CREATE TABLE [dbo].[TThirdParty]
(
[ThirdPartyId] [int] NOT NULL IDENTITY(1, 1),
[ThirdPartyDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TThirdParty_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TThirdParty] ADD CONSTRAINT [PK_TThirdParty] PRIMARY KEY NONCLUSTERED  ([ThirdPartyId])
GO
