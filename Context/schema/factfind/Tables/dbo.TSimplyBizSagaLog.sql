CREATE TABLE [dbo].[TSimplyBizSagaLog]
(
[SimplyBizSagaLogId] [uniqueidentifier] NOT NULL,
[OpportunityId] [uniqueidentifier] NOT NULL,
[StatusCode] [int] NULL,
[Message] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[SimplyBizSagaId] [uniqueidentifier] NOT NULL,
[TenantId] [int] NOT NULL CONSTRAINT [DF_TSimplyBizSagaLog_TenantId] DEFAULT ((10155))
)
GO
