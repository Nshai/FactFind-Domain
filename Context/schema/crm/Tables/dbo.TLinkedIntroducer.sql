CREATE TABLE [dbo].[TLinkedIntroducer]
(
[LinkedIntroducerId] [int] NOT NULL IDENTITY(1, 1),
[CorporateIntroducerId] [int] NOT NULL,
[PersonIntroducerId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLinkedIntroducer_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLinkedIntroducer] ADD CONSTRAINT [PK_TLinkedIntroducer] PRIMARY KEY CLUSTERED  ([LinkedIntroducerId]) WITH (FILLFACTOR=80)
GO

