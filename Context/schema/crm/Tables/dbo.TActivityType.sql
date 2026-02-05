CREATE TABLE [dbo].[TActivityType]
(
[ActivityTypeId] [int] NOT NULL IDENTITY(1, 1),
[Activity] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityT_ConcurrencyId_1__81] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TActivityType] ADD CONSTRAINT [PK_TActivityType_2__81] PRIMARY KEY NONCLUSTERED  ([ActivityTypeId]) WITH (FILLFACTOR=80)
GO
