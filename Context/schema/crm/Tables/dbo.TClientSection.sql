CREATE TABLE [dbo].[TClientSection]
(
[ClientSectionId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[SectionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientSection_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TClientSection] ADD CONSTRAINT [PK_TClientSection_ClientSectionId] PRIMARY KEY NONCLUSTERED  ([ClientSectionId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TClientSection] ADD CONSTRAINT [FK_TClientSection_SectionId_SectionId] FOREIGN KEY ([SectionId]) REFERENCES [dbo].[TSection] ([SectionId])
GO
