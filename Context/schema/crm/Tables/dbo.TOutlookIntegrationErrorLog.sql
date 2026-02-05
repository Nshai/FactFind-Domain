CREATE TABLE [dbo].[TOutlookIntegrationErrorLog]
(
[OutlookIntegrationErrorLogId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[UserId] [int] NULL,
[Timestamp] [datetime] NOT NULL,
[Reference] [varchar] (250)  NULL,
[ErrorMessage] [varchar] (1000)  NULL,
[CallStack] [varchar] (max)  NULL,
[Details] [varchar] (max)  NULL
)
GO
ALTER TABLE [dbo].[TOutlookIntegrationErrorLog] ADD CONSTRAINT [PK_TOutlookIntegrationErrorLog] PRIMARY KEY CLUSTERED  ([OutlookIntegrationErrorLogId] ,[Timestamp] )
GO
