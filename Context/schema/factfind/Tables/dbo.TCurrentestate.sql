CREATE TABLE [dbo].[TCurrentestate]
(
[CurrentestateId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCurrente__Concu__23A93AC7] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCurrentestate_CRMContactId] ON [dbo].[TCurrentestate] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
