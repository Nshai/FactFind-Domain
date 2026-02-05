CREATE TABLE [dbo].[TSwitchRequest]
(
[SwitchRequestId] [int] NOT NULL IDENTITY(1, 1),
[CorrelationId] [uniqueidentifier] NOT NULL,
[RequestDate] [datetime] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[IntegratedSystemId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[UserName] [varchar] (150) COLLATE Latin1_General_CI_AS NOT NULL,
[PlanActionHistoryId] [int] NULL,
[Completed] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[StartMessageProcessing] [datetime] NULL,
[WsCallDurationMillisec] [int] NULL,
[WithdrawalAmount] [money] NULL
)
GO
ALTER TABLE [dbo].[TSwitchRequest] ADD CONSTRAINT [PK_TSwitchRequest] PRIMARY KEY CLUSTERED  ([SwitchRequestId])
GO
