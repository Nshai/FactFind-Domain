CREATE TABLE [dbo].[TBeneficiary]
(
[BeneficiaryId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PersonId] [int] NOT NULL,
[CoporateId] [int] NOT NULL,
[TrustId] [int] NOT NULL,
[ArchiveFG] [tinyint] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBeneficiary_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TBeneficiary] ADD CONSTRAINT [PK_TBeneficiary] PRIMARY KEY NONCLUSTERED  ([BeneficiaryId])
GO
CREATE NONCLUSTERED INDEX [IDX_TBeneficiary_CoporateId] ON [dbo].[TBeneficiary] ([CoporateId])
GO
CREATE NONCLUSTERED INDEX [IDX_TBeneficiary_PersonId] ON [dbo].[TBeneficiary] ([PersonId])
GO
CREATE NONCLUSTERED INDEX [IDX_TBeneficiary_TrustId] ON [dbo].[TBeneficiary] ([TrustId])
GO
ALTER TABLE [dbo].[TBeneficiary] WITH CHECK ADD CONSTRAINT [FK_TBeneficiary_CoporateId_CorporateId] FOREIGN KEY ([CoporateId]) REFERENCES [dbo].[TCorporate] ([CorporateId])
GO
ALTER TABLE [dbo].[TBeneficiary] WITH CHECK ADD CONSTRAINT [FK_TBeneficiary_PersonId_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[TPerson] ([PersonId])
GO
ALTER TABLE [dbo].[TBeneficiary] ADD CONSTRAINT [FK_TBeneficiary_TrustId_TrustId] FOREIGN KEY ([TrustId]) REFERENCES [dbo].[TTrust] ([TrustId])
GO
