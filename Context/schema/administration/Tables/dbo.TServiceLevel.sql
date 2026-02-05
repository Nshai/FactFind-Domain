CREATE TABLE [dbo].[TServiceLevel]
(
[ServiceLevelId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128)  NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ContractHostFg] [bit] NOT NULL CONSTRAINT [DF_TServiceLevel_ContractWithHostFg] DEFAULT ((0)),
[UseNetworkAuthorDocs] [bit] NOT NULL CONSTRAINT [DF_TServiceLevel_UseParentAuthorDocs] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TServiceLevel_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TServiceLevel] ADD CONSTRAINT [PK_TServiceLevel] PRIMARY KEY CLUSTERED  ([ServiceLevelId])
GO
ALTER TABLE [dbo].[TServiceLevel] WITH CHECK ADD CONSTRAINT [FK_TServiceLevel_TIndigoClient] FOREIGN KEY ([IndigoClientId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
