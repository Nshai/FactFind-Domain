CREATE TABLE [dbo].[TNavigationOrder]
(
[NavigationOrderId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TNavigationOrder_ConcurrencyId] DEFAULT ((0)),
[TenantId] [int] NOT NULL,
[RefNavigationItemId] [int] NOT NULL,
[OrderNumber] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[TNavigationOrder] ADD CONSTRAINT [PK_TNavigationOrder] PRIMARY KEY NONCLUSTERED  ([NavigationOrderId])
GO
CREATE CLUSTERED INDEX [IDX_TNavigationOrder_TenantId] ON [dbo].[TNavigationOrder] ([NavigationOrderId])
GO
