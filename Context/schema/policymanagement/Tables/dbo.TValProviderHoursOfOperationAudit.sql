CREATE TABLE [dbo].[TValProviderHoursOfOperationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[AlwaysAvailableFg] [bit] NOT NULL,
[DayOfTheWeek] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[StartHour] [tinyint] NOT NULL CONSTRAINT [DF_TValProviderHoursOfOperationAudit_StartHour] DEFAULT ((0)),
[EndHour] [tinyint] NOT NULL CONSTRAINT [DF_TValProviderHoursOfOperationAudit_EndHour] DEFAULT ((0)),
[StartMinute] [tinyint] NOT NULL CONSTRAINT [DF_TValProviderHoursOfOperationAudit_StartMinute] DEFAULT ((0)),
[EndMinute] [tinyint] NOT NULL CONSTRAINT [DF_TValProviderHoursOfOperationAudit_EndMinute] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValProviderHoursOfOperationAudit_ConcurrencyId] DEFAULT ((1)),
[ValProviderHoursOfOperationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValProviderHoursOfOperationAudit] ADD CONSTRAINT [PK_TValProviderHoursOfOperationAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
