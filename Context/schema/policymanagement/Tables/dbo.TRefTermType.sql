CREATE TABLE [dbo].[TRefTermType]
(
[RefTermTypeId] [int] NOT NULL IDENTITY(1, 1),
[TermTypeName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefTermType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTermType] ADD CONSTRAINT [PK_TRefTermType] PRIMARY KEY CLUSTERED  ([RefTermTypeId])
GO
