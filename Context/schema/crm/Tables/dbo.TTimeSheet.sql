CREATE TABLE [dbo].[TTimeSheet]
(
[TimeSheetId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[ClientCRMContactId] [int] NULL,
[ClientGroupId] [int] NULL,
[Description] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[NumHours] [float] NULL,
[FeeId] [int] NULL,
[HourlyRate] [float] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTimeSheet_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTimeSheet] ADD CONSTRAINT [PK_TTimeSheet] PRIMARY KEY NONCLUSTERED  ([TimeSheetId]) WITH (FILLFACTOR=80)
GO
