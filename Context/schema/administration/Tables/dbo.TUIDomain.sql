CREATE TABLE [dbo].[TUIDomain]
(
[UIDomainId] [int] NOT NULL IDENTITY(1, 1),
[DomainName] [varchar](100) NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUIDomain_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TUIDomain_TenantId] ON [dbo].[TUIDomain] ([TenantId])
GO


