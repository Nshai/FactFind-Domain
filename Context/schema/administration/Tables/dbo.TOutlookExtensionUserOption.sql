CREATE TABLE [dbo].[TOutlookExtensionUserOption]
(
[OutlookExtensionUserOptionId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NULL,
[SyncDiaryAppointments] [bit] NOT NULL,
[IsSetupNotificationSent] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TOutlookExtensionUserOption] ADD CONSTRAINT [PK_TOutlookExtensionUserOption] PRIMARY KEY CLUSTERED  ([OutlookExtensionUserOptionId])
GO