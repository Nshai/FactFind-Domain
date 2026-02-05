CREATE TABLE [dbo].[TFactFindSearch]
(
[FactFindSearchId] [int] NOT NULL IDENTITY(1, 1),
[RefFactFindSearchTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindSearch_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFactFindSearch] ADD CONSTRAINT [PK_TFactFindSearch_FactFindSearchId] PRIMARY KEY NONCLUSTERED  ([FactFindSearchId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TFactFindSearch] ADD CONSTRAINT [FK_TFactFindSearch_RefFactFindSearchTypeId_RefFactFindSearchTypeId] FOREIGN KEY ([RefFactFindSearchTypeId]) REFERENCES [dbo].[TRefFactFindSearchType] ([RefFactFindSearchTypeId])
GO
