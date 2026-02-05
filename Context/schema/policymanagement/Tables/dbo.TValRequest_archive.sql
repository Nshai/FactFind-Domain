CREATE TABLE [dbo].[TValRequest_archive](
	[ValRequestId] [int] IDENTITY(1,1) NOT NULL,
	[PractitionerId] [int] NOT NULL,
	[CRMContactId] [int] NULL,
	[PolicyBusinessId] [int] NULL,
	[PlanValuationId] [bigint] NULL,
	[ValuationType] [varchar](50) NOT NULL,
	[RequestXML] [varchar](6000) NOT NULL,
	[RequestedUserId] [int] NOT NULL,
	[RequestedDate] [datetime] NOT NULL,
	[RequestStatus] [varchar](255) NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[LoggedOnUserId] [int] NULL,
	[ValRequestCorrelationId] [uniqueidentifier] NULL
) 