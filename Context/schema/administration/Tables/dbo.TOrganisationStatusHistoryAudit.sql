CREATE TABLE [dbo].[TOrganisationStatusHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Identifier] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ChangeDateTime] [datetime] NOT NULL CONSTRAINT [DF_TOrganisationStatusHistoryAudit_ChangeDateTime] DEFAULT (getdate()),
[ChangeUser] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOrganisationStatusHistoryAudit_ConcurrencyId] DEFAULT ((1)),
[OrganisationStatusHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOrganisationStatusHistoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOrganisationStatusHistoryAudit] ADD CONSTRAINT [PK_TOrganisationStatusHistoryAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
