CREATE TABLE [dbo].[TActivity]
(
[ActivityId] [int] NOT NULL IDENTITY(1, 1),
[ActivityTypeId] [int] NULL,
[Activity] [varchar] (8000)  NULL,
[CRMContactId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivity_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TActivity] ADD CONSTRAINT [PK_TActivity] PRIMARY KEY NONCLUSTERED  ([ActivityId])
GO
CREATE NONCLUSTERED INDEX [IDX_TActivity_ActivityTypeId] ON [dbo].[TActivity] ([ActivityTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TActivity_CRMContactId] ON [dbo].[TActivity] ([CRMContactId])
GO
ALTER TABLE [dbo].[TActivity] ADD CONSTRAINT [FK_TActivity_ActivityTypeId_ActivityTypeId] FOREIGN KEY ([ActivityTypeId]) REFERENCES [dbo].[TActivityType] ([ActivityTypeId])
GO
ALTER TABLE [dbo].[TActivity] WITH CHECK ADD CONSTRAINT [FK_TActivity_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
