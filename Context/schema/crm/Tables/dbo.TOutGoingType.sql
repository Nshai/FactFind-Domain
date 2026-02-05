CREATE TABLE [dbo].[TOutGoingType]
(
[OutGoingTypeId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOutGoingT_ConcurrencyId_1__56] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOutGoingType] ADD CONSTRAINT [PK_TOutGoingType_2__56] PRIMARY KEY NONCLUSTERED  ([OutGoingTypeId]) WITH (FILLFACTOR=80)
GO
