CREATE TABLE [dbo].[TEvent]
(
[EventId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[IndUserId] [int] NOT NULL,
[RefSubjectId] [int] NULL,
[Subject] [varchar] (255)  NULL,
[Location] [varchar] (255)  NULL,
[PersonId] [int] NULL,
[ContactName] [varchar] (255)  NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[Notes] [varchar] (8000)  NULL,
[ArchiveFG] [tinyint] NOT NULL CONSTRAINT [DF_TEvent_ArchiveFG] DEFAULT ((0)),
[CompleteFG] [tinyint] NOT NULL CONSTRAINT [DF_TEvent_CompleteFG] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvent_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvent] ADD CONSTRAINT [PK_TEvent] PRIMARY KEY NONCLUSTERED  ([EventId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvent_PersonId] ON [dbo].[TEvent] ([PersonId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvent_RefSubjectId] ON [dbo].[TEvent] ([RefSubjectId])
GO
ALTER TABLE [dbo].[TEvent] WITH CHECK ADD CONSTRAINT [FK_TEvent_PersonId_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[TPerson] ([PersonId])
GO
ALTER TABLE [dbo].[TEvent] ADD CONSTRAINT [FK_TEvent_RefSubjectId_RefSubjectId] FOREIGN KEY ([RefSubjectId]) REFERENCES [dbo].[TRefSubject] ([RefSubjectId])
GO
