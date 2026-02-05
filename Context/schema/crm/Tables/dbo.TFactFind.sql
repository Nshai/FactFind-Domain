CREATE TABLE [dbo].[TFactFind]
(
[FactFindId] [int] NOT NULL IDENTITY(1, 1),
[DocumentId] [int] NOT NULL,
[LatestDocVerId] [int] NOT NULL,
[VersionDate] [datetime] NOT NULL,
[CreatedByUserId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFind_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFactFind] ADD CONSTRAINT [PK_TFactFind] PRIMARY KEY NONCLUSTERED  ([FactFindId]) WITH (FILLFACTOR=80)
GO
