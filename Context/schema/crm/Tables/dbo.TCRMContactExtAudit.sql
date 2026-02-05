CREATE TABLE [dbo].[TCRMContactExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[CreditedGroupId] [int] NULL,
[ExternalSystemId] [int] NULL,
[ExternalId] [varchar] (100) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCRMContactExtAudit_ConcurrencyId] DEFAULT ((1)),
[CRMContactExtId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCRMContactExtAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
[ExternalSystem] [varchar] (100) NULL,
[ServicingAdminUserId] [int] NULL,
[ParaplannerUserId] [int] NULL,
[ReportFrequency] [int] NULL,
[ReportStartDate] [datetime] NULL,
[ClientServicingDeliveryMethod] [varchar] (50) NULL,
[TaxReferenceNumber] [varchar](50) NULL,
[IsTargetMarket] [bit] NULL,
[TargetMarketExplanation] [varchar](250) NULL,
[DateClientRestricted] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TCRMContactExtAudit] ADD CONSTRAINT [PK_TCRMContactExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
