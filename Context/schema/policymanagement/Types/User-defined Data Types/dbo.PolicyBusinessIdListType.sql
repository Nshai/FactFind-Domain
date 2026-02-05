CREATE TYPE [dbo].[PolicyBusinessIdListType] AS TABLE
(
[PolicyBusinessId] [bigint] NOT NULL,
UNIQUE NONCLUSTERED  ([PolicyBusinessId])
)
GO
