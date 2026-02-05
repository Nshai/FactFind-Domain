CREATE TABLE [dbo].[TRefClassification]
(
[RefClassificationId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Colour] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL,
[UserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefClassification] ADD CONSTRAINT [PK_TRefClassification] PRIMARY KEY CLUSTERED  ([RefClassificationId])
GO
