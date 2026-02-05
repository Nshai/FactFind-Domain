CREATE TABLE [dbo].[TGroupPMISchemeCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GroupSchemeCategoryId] [int] NOT NULL,
[RefUnderwritingId] [int] NULL,
[MemberExcess] [money] NULL,
[HospitalScale] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
[RefCancerCoverId] [int] NULL,
[HasOutpatientDiagnosticTestsAndScans] [bit] NULL,
[HasOutpatientConsultationsAndTreatment] [bit] NULL,
[HasOutpatientPsychiatricTreatment] [bit] NULL,
[HasDentalCover] [bit] NULL,
[DentalScale] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
[HasTravelCover] [bit] NULL,
[HasPrivateGPCover] [bit] NULL,
[HasCoverLinkedToGroupLife] [bit] NULL,
[IsOpticalBenefit] [bit] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[GroupPMISchemeCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupPMISchemeCategoryAudit] ADD CONSTRAINT [PK_TGroupPMISchemeCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
