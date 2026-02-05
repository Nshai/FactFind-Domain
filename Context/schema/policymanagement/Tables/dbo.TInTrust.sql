CREATE TABLE [dbo].[TInTrust]
(
[InTrustId] [int] NOT NULL IDENTITY(1, 1),
[ToWhom] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InTrustFG] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TInTrust] ADD CONSTRAINT [PK_TInTrust] PRIMARY KEY CLUSTERED  ([InTrustId])
GO
