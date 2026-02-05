CREATE TABLE [dbo].[TValRequest]
(
[ValRequestId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PractitionerId] [int] NOT NULL,
[CRMContactId] [int] NULL,
[PolicyBusinessId] [int] NULL,
[PlanValuationId] [bigint] NULL,
[ValuationType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RequestXML] [varchar] (6000) COLLATE Latin1_General_CI_AS NOT NULL,
[LoggedOnUserId] [int] NULL,
[RequestedUserId] [int] NOT NULL,
[RequestedDate] [datetime] NOT NULL,
[RequestStatus] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValRequest_ConcurrencyId] DEFAULT ((1)),
[ValRequestCorrelationId] [uniqueidentifier] NULL
)
GO
ALTER TABLE [dbo].[TValRequest] ADD CONSTRAINT [PK_TValRequest] PRIMARY KEY CLUSTERED  ([ValRequestId])
GO
CREATE NONCLUSTERED INDEX [IX_TValRequest_PlanValuationId_ValRequestId] ON [dbo].[TValRequest] ([PlanValuationId], [ValRequestId])
GO
CREATE NONCLUSTERED INDEX [IDX_TValRequest_PolicyBusinessId] ON [dbo].[TValRequest] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IX_TValRequest_PolicyBusinessId] ON [dbo].[TValRequest] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IX_TValRequest_RequestedUserId] ON [dbo].[TValRequest] ([RequestedUserId])
GO
