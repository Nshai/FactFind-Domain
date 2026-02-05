CREATE TABLE [dbo].[TTrustee]
(
[TrusteeId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PersonId] [int] NOT NULL,
[CorporateId] [int] NOT NULL,
[DefaultFG] [tinyint] NOT NULL,
[ArchiveFG] [tinyint] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTrustee_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTrustee] ADD CONSTRAINT [PK_TTrustee] PRIMARY KEY NONCLUSTERED  ([TrusteeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTrustee_CorporateId] ON [dbo].[TTrustee] ([CorporateId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTrustee_PersonId] ON [dbo].[TTrustee] ([PersonId])
GO
ALTER TABLE [dbo].[TTrustee] WITH CHECK ADD CONSTRAINT [FK_TTrustee_CorporateId_CorporateId] FOREIGN KEY ([CorporateId]) REFERENCES [dbo].[TCorporate] ([CorporateId])
GO
ALTER TABLE [dbo].[TTrustee] WITH CHECK ADD CONSTRAINT [FK_TTrustee_PersonId_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[TPerson] ([PersonId])
GO
