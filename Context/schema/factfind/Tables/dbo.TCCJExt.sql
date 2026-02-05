CREATE TABLE [dbo].[TCCJExt]
(
[CCJExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[CCJDefaultFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCCJExt_ConcurrencyId] DEFAULT ((1))
)
GO
