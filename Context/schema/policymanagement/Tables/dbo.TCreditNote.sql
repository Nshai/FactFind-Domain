CREATE TABLE [dbo].[TCreditNote]
(
[CreditNoteId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NULL,
[RetainerId] [int] NULL,
[ProvBreakId] [int] NULL,
[NetAmount] [money] NULL,
[VATAmount] [money] NULL,
[DateRaised] [datetime] NULL,
[SentToClientDate] [datetime] NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[SequentialRefLegacy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SequentialRef]  AS (case when [SequentialRefLegacy] IS NULL then 'IOC'+right(replicate('0',(8))+CONVERT([varchar],[CreditNoteId]),(8)) collate Latin1_General_CI_AS else [SequentialRefLegacy] end),
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TCreditNot_ConcurrencyId_3__56] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCreditNote] ADD CONSTRAINT [PK_TCreditNote_4__56] PRIMARY KEY NONCLUSTERED  ([CreditNoteId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCreditNote_FeeId] ON [dbo].[TCreditNote] ([FeeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TCreditNote] ADD CONSTRAINT [FK_TCreditNote_FeeId_FeeId] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId])
GO
CREATE NONCLUSTERED INDEX IX_TCreditNote_RetainerId ON [dbo].[TCreditNote] ([RetainerId]) INCLUDE ([CreditNoteId],[ProvBreakId],[NetAmount],[ConcurrencyId])
go