CREATE TABLE [dbo].[TProtectionNeeds]
(
[ProtectionNeedsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[SalaryExpRelianceYN] [bit] NULL,
[SalaryWhoReliance] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[SicknessMaintenanceDet] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[DeathMaintenanceDet] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[BenefitsUnderWrittenYN] [bit] NULL,
[BorrowingsCoveredYN] [bit] NULL,
[BorrowingsCoveredDet] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[IncomeCoverShortDet] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[IncomeCoverLongDet] [bit] NULL,
[PartnerWorkonDeathYN] [bit] NULL,
[WorkonDeathofPartnerYN] [bit] NULL,
[ReqCIApproachYN] [bit] NULL,
[PrescriptiveMedYN] [bit] NULL,
[MedicalNotes] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProtecti__Concu__164F3FA9] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TProtectionNeeds_CRMContactId] ON [dbo].[TProtectionNeeds] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
