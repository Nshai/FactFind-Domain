CREATE TABLE [dbo].[TEventList]
(
[EventListId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[EventListTemplateId] [int] NOT NULL,
[OwnerUserId] [int] NOT NULL,
[StartDate] [datetime] NULL,
[ClientCRMContactId] [int] NOT NULL,
[JointClientCRMContactId] [int] NULL,
[PlanId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AdviceCaseId] [int] NULL
)
GO
ALTER TABLE [dbo].[TEventList] ADD CONSTRAINT [PK_TEventList] PRIMARY KEY CLUSTERED  ([EventListId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TEventList_IndigoClientId] ON [dbo].[TEventList] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TEventList] ADD CONSTRAINT [FK_TEventList_TEventListTemplate] FOREIGN KEY ([EventListTemplateId]) REFERENCES [dbo].[TEventListTemplate] ([EventListTemplateId])
GO
