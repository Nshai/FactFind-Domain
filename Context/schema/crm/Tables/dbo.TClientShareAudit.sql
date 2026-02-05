CREATE TABLE [dbo].[TClientShareAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ClientShareId] [int] NOT NULL,
[ClientPartyId] [int] NOT NULL,
[SharedByCRMContactId] [int] NOT NULL,
[SharedToCRMContactId] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NULL,
[ShareEndedByCRMContactId] [int] NULL,
[IsShareActive] [bit] NOT NULL CONSTRAINT [DF_TClientShareAudit_1_IsShareEnd] DEFAULT ((1)),
[ShareIdentifier] [uniqueidentifier] NOT NULL,
[OrganiserActivityId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientShareAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientShareAudit] ADD CONSTRAINT [PK_TClientShareAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
