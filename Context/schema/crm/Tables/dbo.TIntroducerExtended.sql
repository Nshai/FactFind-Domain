CREATE TABLE [dbo].[TIntroducerExtended]
(
[IntroducerExtendedId] [int] NOT NULL IDENTITY(1, 1),
[IntroducerId] [int] NOT NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntroducerExtended_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIntroducerExtended] ADD CONSTRAINT [PK_TIntroducerExtended] PRIMARY KEY NONCLUSTERED  ([IntroducerExtendedId]) WITH (FILLFACTOR=80)
GO
create index IX_TIntroducerExtended_MigrationRef on TIntroducerExtended(MigrationRef) 
go 
