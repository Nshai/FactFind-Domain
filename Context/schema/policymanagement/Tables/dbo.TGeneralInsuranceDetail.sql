CREATE TABLE [dbo].[TGeneralInsuranceDetail]
(
[GeneralInsuranceDetailId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ProtectionId] [int] NOT NULL,
[SumAssured] [decimal] (18, 6) NULL,
[AdditionalCoverAmount] [decimal] (18, 6) NULL,
[Owner2PercentageOfSumAssured] [decimal] (18, 6) NULL,
[ExcessAmount] [decimal] (18, 6) NULL,
[RefInsuranceCoverCategoryId] [int] NOT NULL,
[InsuranceCoverOptions] [int] NOT NULL,
[RefInsuranceCoverAreaId] [int] NOT NULL,
[RefInsuranceCoverTypeId] [int] NOT NULL,
[IsCoverNoteIssued] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGeneralInsuranceDetail_ConcurrencyId] DEFAULT ((1)),
[PlanMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PolicyBusinessId] [int] NULL,
[IndigoClientId] [int] NULL
)
GO
ALTER TABLE [dbo].[TGeneralInsuranceDetail] ADD CONSTRAINT [PK_TGeneralInsuranceDetail] PRIMARY KEY CLUSTERED  ([GeneralInsuranceDetailId])
GO
CREATE NONCLUSTERED INDEX [IDX_TGeneralInsuranceDetail_ProtectionId] ON [dbo].[TGeneralInsuranceDetail] ([ProtectionId]) INCLUDE ([SumAssured])
GO
CREATE NONCLUSTERED INDEX [IDX_TGeneralInsuranceDetail_PlanMigrationRef] ON [dbo].[TGeneralInsuranceDetail] ([PlanMigrationRef])
GO