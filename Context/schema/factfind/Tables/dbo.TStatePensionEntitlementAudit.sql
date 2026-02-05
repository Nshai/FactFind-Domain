CREATE TABLE [dbo].[TStatePensionEntitlementAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StatePensionEntitlementId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[StatePensionRetirementAge] [tinyint] NULL,
[BasicStatePension] [money] NULL,
[AdditionalStatePension] [money] NULL,
[PensionCredit] [money] NULL,
[SpousesPension] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[BR19Projection] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Notes] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TStatePensionEntitlement_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TStatePensionEntitlementAudit] ADD CONSTRAINT [PK_TStatePensionEntitlementAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TStatePensionEntitlementAudit_Id_ConcurrencyId] ON [dbo].[TStatePensionEntitlementAudit] ([StatePensionEntitlementId], [ConcurrencyId]) WITH (FILLFACTOR=75)
GO
