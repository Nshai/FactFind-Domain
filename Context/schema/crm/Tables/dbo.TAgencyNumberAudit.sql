CREATE TABLE [dbo].[TAgencyNumberAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PractitionerId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[AgencyNumber] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[DateChanged] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAgencyNumberAudit_ConcurrencyId] DEFAULT ((1)),
[AgencyNumberId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAgencyNumberAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAgencyNumberAudit] ADD CONSTRAINT [PK_TAgencyNumberAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
