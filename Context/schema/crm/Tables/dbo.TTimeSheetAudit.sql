CREATE TABLE [dbo].[TTimeSheetAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NULL,
[ClientCRMContactId] [int] NULL,
[ClientGroupId] [int] NULL,
[Description] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[NumHours] [float] NULL,
[FeeId] [int] NULL,
[HourlyRate] [float] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[TimeSheetId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTimeSheet_StampDateTime_1__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTimeSheetAudit] ADD CONSTRAINT [PK_TTimeSheetAudit_2__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TTimeSheetAudit_TimeSheetId_ConcurrencyId] ON [dbo].[TTimeSheetAudit] ([TimeSheetId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
