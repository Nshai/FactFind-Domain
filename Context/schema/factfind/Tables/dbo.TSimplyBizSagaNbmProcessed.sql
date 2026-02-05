CREATE TABLE [dbo].[TSimplyBizSagaNbmProcessed]
(
[SimplyBizSagaNbmProcessedId] [uniqueidentifier] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[TenantId] [int] NOT NULL CONSTRAINT [DF_TSimplyBizSagaNbmProcessed_TenantId] DEFAULT ((10155))
)
GO
