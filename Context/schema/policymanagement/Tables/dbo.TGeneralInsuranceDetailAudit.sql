CREATE TABLE [dbo].[TGeneralInsuranceDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ProtectionId] [int] NOT NULL,
[SumAssured] [decimal] (18, 0) NULL,
[AdditionalCoverAmount] [decimal] (18, 6) NULL,
[Owner2PercentageOfSumAssured] [decimal] (18, 6) NULL,
[ExcessAmount] [decimal] (18, 6) NULL,
[RefInsuranceCoverCategoryId] [int] NOT NULL,
[InsuranceCoverOptions] [int] NOT NULL,
[RefInsuranceCoverAreaId] [int] NOT NULL,
[RefInsuranceCoverTypeId] [int] NOT NULL,
[IsCoverNoteIssued] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[GeneralInsuranceDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TGeneralInsuranceDetailAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PlanMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PolicyBusinessId] [int] NULL,
[IndigoClientId] [int] NULL
)
GO
ALTER TABLE [dbo].[TGeneralInsuranceDetailAudit] ADD CONSTRAINT [PK_TGeneralInsuranceDetailAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO