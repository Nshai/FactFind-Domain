CREATE TABLE [dbo].[TCurrentestateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ValidWillYN] [bit] NULL,
[WillPreparedDate] [datetime] NULL,
[WillReviewedDate] [datetime] NULL,
[WillStored] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[WillChangesSinceYN] [bit] NULL,
[WillTestamentaryTrustsYN] [bit] NULL,
[AwareofTrustBenefitsYN] [bit] NULL,
[IHTLiabilityBeneficiaryProbYN] [bit] NULL,
[ConsiderIHTSolutionsYN] [bit] NULL,
[IHTPriorityYN] [bit] NULL,
[PowerofAttorneyYN] [bit] NULL,
[PowerofAttorneyType] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[PowerofAttorneyRegYN] [bit] NULL,
[MedicalRepYN] [bit] NULL,
[FurtherAdviceYN] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[CurrentestateId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCurrente__Concu__7760A435] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCurrentestateAudit] ADD CONSTRAINT [PK_TCurrentestateAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
