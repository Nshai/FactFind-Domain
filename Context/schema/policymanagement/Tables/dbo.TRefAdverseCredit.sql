CREATE TABLE [dbo].[TRefAdverseCredit]
(
[RefAdverseCreditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAdverseCredit_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefAdverseCredit] ADD CONSTRAINT [PK_TRefAdverseCredit] PRIMARY KEY CLUSTERED  ([RefAdverseCreditId])
GO
