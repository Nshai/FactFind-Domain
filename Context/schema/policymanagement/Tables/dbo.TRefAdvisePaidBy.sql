CREATE TABLE [dbo].[TRefAdvisePaidBy]
(
[RefAdvisePaidById] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[IsPaidByProvider] [bit] NOT NULL CONSTRAINT [DF_TRefAdvisePaidBy_IsPaidByProvider] DEFAULT (0)
)
GO
ALTER TABLE [dbo].[TRefAdvisePaidBy] ADD CONSTRAINT [PK_TRefAdvisePaidBy] PRIMARY KEY CLUSTERED  ([RefAdvisePaidById])
GO