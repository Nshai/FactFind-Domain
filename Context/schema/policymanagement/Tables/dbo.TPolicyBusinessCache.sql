CREATE TABLE [dbo].[TPolicyBusinessCache]
(
[PolicyBusinessCacheId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[CachedHTML] [text] COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessCache_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyBusinessCache] ADD CONSTRAINT [PK_TPolicyBusinessCache] PRIMARY KEY CLUSTERED  ([PolicyBusinessCacheId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyBusinessCache] ON [dbo].[TPolicyBusinessCache] ([PolicyBusinessId]) WITH (FILLFACTOR=90)
GO
