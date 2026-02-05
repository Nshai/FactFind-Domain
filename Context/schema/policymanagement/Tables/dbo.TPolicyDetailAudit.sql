CREATE TABLE [dbo].[TPolicyDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PlanDescriptionId] [int] NOT NULL,
[TermYears] [tinyint] NULL,
[WholeOfLifeFg] [bit] NULL,
[LetterOfAuthorityFg] [bit] NULL CONSTRAINT [DF_TPolicyDet_LetterOfAuthorityFg_2__56] DEFAULT ((0)),
[ContractOutOfSERPSFg] [bit] NULL,
[ContractOutStartDate] [datetime] NULL,
[ContractOutStopDate] [datetime] NULL,
[AssignedCRMContactId] [int] NULL,
[JoiningDate] [datetime] NULL,
[LeavingDate] [datetime] NULL,
[IndigoClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyDet_ConcurrencyId_1__56] DEFAULT ((1)),
[PolicyDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyDet_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PlanMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GrossAnnualIncome] [money] NULL,
[RefAnnuityPaymentTypeId] [int] NULL,
[CapitalElement] [money] NULL,
[AssumedGrowthRatePercentage] [decimal] (5, 2) NULL
)
GO
ALTER TABLE [dbo].[TPolicyDetailAudit] ADD CONSTRAINT [PK_TPolicyDetailAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyDetailAudit_PolicyDetailId_ConcurrencyId] ON [dbo].[TPolicyDetailAudit] ([PolicyDetailId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IX_TPolicyDetailAudit_StampDateTime_PolicyDetailId] ON [dbo].[TPolicyDetailAudit] ([StampDateTime], [PolicyDetailId]) WITH (FILLFACTOR=90)
GO
