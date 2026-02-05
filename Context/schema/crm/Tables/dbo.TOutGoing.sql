CREATE TABLE [dbo].[TOutGoing]
(
[OutGoingId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[OutGoingTypeId] [int] NOT NULL,
[Frequency] [varchar] (50)  NOT NULL,
[Amount] [money] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOutGoing_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOutGoing] ADD CONSTRAINT [PK_TOutGoing] PRIMARY KEY NONCLUSTERED  ([OutGoingId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOutGoing_CRMContactId] ON [dbo].[TOutGoing] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOutGoing_OutGoingTypeId] ON [dbo].[TOutGoing] ([OutGoingTypeId])
GO
ALTER TABLE [dbo].[TOutGoing] WITH CHECK ADD CONSTRAINT [FK_TOutGoing_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TOutGoing] ADD CONSTRAINT [FK_TOutGoing_OutGoingTypeId_OutGoingTypeId] FOREIGN KEY ([OutGoingTypeId]) REFERENCES [dbo].[TOutGoingType] ([OutGoingTypeId])
GO
