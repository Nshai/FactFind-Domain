CREATE TABLE [dbo].[TUserCalendarConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[DateTime] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[UserCalendarConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TUserCalendarConfigAudit] ADD CONSTRAINT [PK_TUserCalendarConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
