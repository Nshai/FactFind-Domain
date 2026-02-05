CREATE TABLE [dbo].[TCheckList]
(
[CheckListId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ReferenceNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[URL] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCheckList_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCheckList] ADD CONSTRAINT [PK_TCheckList] PRIMARY KEY NONCLUSTERED  ([CheckListId]) WITH (FILLFACTOR=80)
GO
