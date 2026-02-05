CREATE TABLE [dbo].[TProtectionNeedsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[CRMContactId] [int] NOT NULL,
[ProtectionNeedsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProtecti__Concu__6A06A917] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProtectionNeedsAudit] ADD CONSTRAINT [PK_TProtectionNeedsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
