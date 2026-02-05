CREATE TABLE [dbo].[TActivityRecurrence]
(
[ActivityRecurrenceId] [int] NOT NULL IDENTITY(1, 1),
[RFCCode] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[OrganiserActivityId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityRecurrence_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TActivityRecurrence] ADD CONSTRAINT [PK__TActivit__41AF424964C39C64] PRIMARY KEY CLUSTERED  ([ActivityRecurrenceId])
GO
CREATE NONCLUSTERED INDEX [IDX_TActivityRecurrence_OrganiserActivityId] ON [dbo].[TActivityRecurrence] ([OrganiserActivityId])
GO
ALTER TABLE [dbo].[TActivityRecurrence] ADD CONSTRAINT [FK_TActivityRecurrence_TOrganiserActivity] FOREIGN KEY ([OrganiserActivityId]) REFERENCES [dbo].[TOrganiserActivity] ([OrganiserActivityId]) ON DELETE CASCADE
GO
