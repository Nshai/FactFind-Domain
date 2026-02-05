CREATE TABLE [dbo].[TAttributeList]
(
[AttributeListId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Type] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAttribute_ConcurrencyId_1__51] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAttributeList] ADD CONSTRAINT [PK_TAttributeList_2__51] PRIMARY KEY NONCLUSTERED  ([AttributeListId]) WITH (FILLFACTOR=80)
GO
