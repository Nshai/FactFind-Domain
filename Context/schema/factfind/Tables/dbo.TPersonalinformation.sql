CREATE TABLE [dbo].[TPersonalinformation]
(
[PersonalinformationId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NoMarketingInfoByPost] [bit] NULL,
[NoMarketingInfoByEmail] [bit] NULL,
[NoMarketingByPhone] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPersonal__Concu__310335E5] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPersonalinformation_CRMContactId] ON [dbo].[TPersonalinformation] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
