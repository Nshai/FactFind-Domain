CREATE TABLE [dbo].[TPolicyDetail]
(
[PolicyDetailId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PlanDescriptionId] [int] NOT NULL,
[TermYears] [tinyint] NULL,
[WholeOfLifeFg] [bit] NULL,
[LetterOfAuthorityFg] [bit] NULL CONSTRAINT [DF_TPolicyDet_LetterOfAuthorityFg_8__59] DEFAULT ((0)),
[ContractOutOfSERPSFg] [bit] NULL,
[ContractOutStartDate] [datetime] NULL,
[ContractOutStopDate] [datetime] NULL,
[AssignedCRMContactId] [int] NULL,
[JoiningDate] [datetime] NULL,
[LeavingDate] [datetime] NULL,
[IndigoClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyDet_ConcurrencyId_2__59] DEFAULT ((1)),
[PlanMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GrossAnnualIncome] [money] NULL,
[RefAnnuityPaymentTypeId] [int] NULL,
[CapitalElement] [money] NULL,
[AssumedGrowthRatePercentage] [decimal] (5, 2) NULL
)
GO
ALTER TABLE [dbo].[TPolicyDetail] ADD CONSTRAINT [PK_TPolicyDetail_13__59] PRIMARY KEY NONCLUSTERED  ([PolicyDetailId]) WITH (FILLFACTOR=90)
GO
CREATE CLUSTERED INDEX [IDX1_TPolicyDetail_IndigoClientId_PlanDescriptionId] ON [dbo].[TPolicyDetail] ([IndigoClientId], [PlanDescriptionId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyDetail_PlanDescriptionId_PolicyDetailId] ON [dbo].[TPolicyDetail] ([PlanDescriptionId], [PolicyDetailId]) WITH (FILLFACTOR=90)
GO
ALTER TABLE [dbo].[TPolicyDetail] ADD CONSTRAINT [FK_TPolicyDetail_PlanDescriptionId_PlanDescriptionId] FOREIGN KEY ([PlanDescriptionId]) REFERENCES [dbo].[TPlanDescription] ([PlanDescriptionId])
GO
create index IX_TPolicyDetail_PlanMigrationRef_IndigoClientId on TPolicyDetail(PlanMigrationRef,IndigoClientId) 
go 
