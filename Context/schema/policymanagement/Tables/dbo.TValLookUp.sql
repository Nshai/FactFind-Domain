CREATE TABLE [dbo].[TValLookUp]
(
[ValLookUpId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefProdProviderId] [int] NOT NULL,
[MappedRefProdProviderId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TValLookUp] ADD CONSTRAINT [PK_TValLookUp] PRIMARY KEY CLUSTERED  ([ValLookUpId])
GO
