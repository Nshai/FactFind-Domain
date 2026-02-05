CREATE TABLE [dbo].[TSector]
(
[SectorId] [int] NOT NULL IDENTITY(1, 1),
[FundTypeId] [int] NOT NULL,
[FeedId] [varchar] (50)  NOT NULL,
[Name] [varchar] (255)  NOT NULL,
[Description] [varchar] (1000)  NULL,
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_TSector_UpdatedDate] DEFAULT (getdate()),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TSector_CreatedDate] DEFAULT (getdate()),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSector_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSector] ADD CONSTRAINT [PK_TSector_SectorId] PRIMARY KEY NONCLUSTERED  ([SectorId])
GO
ALTER TABLE [dbo].[TSector] WITH CHECK ADD CONSTRAINT [FK_TSector_FundTypeId_FundTypeId] FOREIGN KEY ([FundTypeId]) REFERENCES [dbo].[TFundType] ([FundTypeId])
GO
