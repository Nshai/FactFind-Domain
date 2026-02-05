CREATE TABLE [dbo].[TGroupPMISchemeCategory]
(
[GroupPMISchemeCategoryId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TGroupPMISchemeCategory] ADD CONSTRAINT [PK_TGroupPMISchemeCategory] PRIMARY KEY CLUSTERED  ([GroupPMISchemeCategoryId])
GO
