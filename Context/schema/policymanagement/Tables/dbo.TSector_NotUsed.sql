CREATE TABLE [dbo].[TSector_NotUsed]
(
[SectorId] [int] NOT NULL IDENTITY(1, 1),
[FundTypeId] [int] NOT NULL,
[FeedId] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_TSector_UpdatedDate] DEFAULT (getdate()),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TSector_CreatedDate] DEFAULT (getdate()),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSector_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSector_NotUsed] ADD CONSTRAINT [PK_TSector_SectorId] PRIMARY KEY NONCLUSTERED  ([SectorId]) WITH (FILLFACTOR=80)
GO
