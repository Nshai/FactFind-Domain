CREATE TABLE [dbo].[TIntroducer]
(
[IntroducerId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[AgreementDate] [datetime] NULL,
[RefIntroducerTypeId] [int] NOT NULL,
[PractitionerId] [int] NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TIntroducer_ArchiveFG] DEFAULT ((0)),
[Identifier] [varchar] (50) NULL,
[UniqueIdentifier] [varchar] (255) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntroducer_ConcurrencyId] DEFAULT ((1)),
MigrationRef varchar(255) null
)
GO
ALTER TABLE [dbo].[TIntroducer] ADD CONSTRAINT [PK_TIntroducer] PRIMARY KEY CLUSTERED  ([IntroducerId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIntroducer_CRMContactId] ON [dbo].[TIntroducer] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIntroducer_PractitionerId] ON [dbo].[TIntroducer] ([PractitionerId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIntroducer_RefIntroducerTypeId] ON [dbo].[TIntroducer] ([RefIntroducerTypeId])
GO
ALTER TABLE [dbo].[TIntroducer] WITH CHECK ADD CONSTRAINT [FK_TIntroducer_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TIntroducer] WITH CHECK ADD CONSTRAINT [FK_TIntroducer_PractitionerId_PractitionerId] FOREIGN KEY ([PractitionerId]) REFERENCES [dbo].[TPractitioner] ([PractitionerId])
GO
ALTER TABLE [dbo].[TIntroducer] WITH CHECK ADD CONSTRAINT [FK_TIntroducer_RefIntroducerTypeId_RefIntroducerTypeId] FOREIGN KEY ([RefIntroducerTypeId]) REFERENCES [dbo].[TRefIntroducerType] ([RefIntroducerTypeId])
GO
create index IX_TIntroducer_IndClientId_MigrationRef on TIntroducer(IndClientId,MigrationRef) 
go 
