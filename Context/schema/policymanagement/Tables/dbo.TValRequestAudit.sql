CREATE TABLE [dbo].[TValRequestAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[PractitionerId] [int] NOT NULL,
	[CRMContactId] [int] NULL,
	[PolicyBusinessId] [int] NULL,
	[PlanValuationId] [bigint] NULL,
	[ValuationType] [varchar](50) NOT NULL,
	[RequestXML] [varchar](6000) NOT NULL,
	[LoggedOnUserId] [int] NULL,
	[RequestedUserId] [int] NOT NULL,
	[RequestedDate] [datetime] NOT NULL,
	[RequestStatus] [varchar](255) NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[ValRequestCorrelationId] [uniqueidentifier] NULL,
	[ValRequestId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NOT NULL,
	[StampUser] [varchar](255) NULL
	)
GO

ALTER TABLE [dbo].[TValRequestAudit] ADD  CONSTRAINT [PK_TValRequestAudit_AuditId] PRIMARY KEY CLUSTERED  (	[AuditId] ,	[StampDateTime]  ) 
GO

ALTER TABLE [dbo].[TValRequestAudit] ADD  CONSTRAINT [DF_TValRequestAudit_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO

ALTER TABLE [dbo].[TValRequestAudit] ADD  CONSTRAINT [DF_TValRequestAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]
GO


