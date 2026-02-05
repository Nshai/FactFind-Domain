CREATE TABLE [dbo].[TEmailMailingList]
(
[EmailMailingListId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[OwnerId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailMailingList_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEmailMailingList] ADD CONSTRAINT [PK_TEmailMailingList] PRIMARY KEY CLUSTERED  ([EmailMailingListId]) WITH (FILLFACTOR=80)
GO
