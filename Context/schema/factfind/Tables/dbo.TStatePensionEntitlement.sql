CREATE TABLE [dbo].[TStatePensionEntitlement]
(
[StatePensionEntitlementId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[StatePensionRetirementAge] [tinyint] NULL,
[BasicStatePension] [money] NULL,
[AdditionalStatePension] [money] NULL,
[PensionCredit] [money] NULL,
[SpousesPension] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[BR19Projection] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Notes] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TStatePensionEntitlement_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TStatePensionEntitlement] ADD CONSTRAINT [PK_TStatePensionEntitlement] PRIMARY KEY NONCLUSTERED  ([StatePensionEntitlementId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TStatePensionEntitlement_CRMContactId] ON [dbo].[TStatePensionEntitlement] ([CRMContactId])
GO
