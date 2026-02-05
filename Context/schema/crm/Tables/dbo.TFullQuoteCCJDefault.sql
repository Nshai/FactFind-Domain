CREATE TABLE [dbo].[TFullQuoteCCJDefault]
(
[FullQuoteCCJDefaultId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[CCJDefaultId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteCCJDefault_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFullQuoteCCJDefault] ADD CONSTRAINT [PK_TFullQuoteCCJDefault] PRIMARY KEY NONCLUSTERED  ([FullQuoteCCJDefaultId])
GO
