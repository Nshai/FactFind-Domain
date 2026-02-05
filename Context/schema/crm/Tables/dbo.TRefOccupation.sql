CREATE TABLE [dbo].[TRefOccupation]
(
[RefOccupationId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[OrigoCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefOccupation_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefOccupation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefOccupation] ADD CONSTRAINT [PK_TRefOccupation] PRIMARY KEY NONCLUSTERED  ([RefOccupationId]) WITH (FILLFACTOR=80)
GO
CREATE UNIQUE CLUSTERED INDEX [IDX_UNQ_TRefOccupation_RefOccupationId] ON [dbo].[TRefOccupation] ([RefOccupationId]) WITH (FILLFACTOR=80)
GO
