CREATE TABLE [dbo].[TEstatePlanning]
(
[EstatePlanningId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[hasWill] [bit] NOT NULL,
[WillUpdate] [datetime] NULL,
[hasCircumstancesChanged] [bit] NULL,
[hasGiftsGiven] [bit] NOT NULL,
[GivenDetails] [varchar] (250)  NULL,
[hasGiftsReceived] [bit] NOT NULL,
[ReceivedDetails] [varchar] (250)  NULL,
[IsAllowanceUsed] [bit] NOT NULL,
[IHTEstimate] [money] NULL,
[Notes] [varchar] (8000)  NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEstatePlanning_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEstatePlanning] ADD CONSTRAINT [PK_TEstatePlanning] PRIMARY KEY NONCLUSTERED  ([EstatePlanningId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEstatePlanning_CRMContactId] ON [dbo].[TEstatePlanning] ([CRMContactId])
GO
ALTER TABLE [dbo].[TEstatePlanning] WITH CHECK ADD CONSTRAINT [FK_TEstatePlanning_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
