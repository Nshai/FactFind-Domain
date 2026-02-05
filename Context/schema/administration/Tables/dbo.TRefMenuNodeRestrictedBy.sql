CREATE TABLE [dbo].[TRefMenuNodeRestrictedBy]
(
[RefMenuNodeRestrictedById] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefMenuNodeRestrictedBy_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefMenuNodeRestrictedBy] ADD CONSTRAINT [PK_TRefMenuNodeRestrictedBy] PRIMARY KEY CLUSTERED  ([RefMenuNodeRestrictedById])
GO
