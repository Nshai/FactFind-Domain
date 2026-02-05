CREATE TABLE [dbo].[TEstateneedsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LeaveAssetsYN] [bit] NULL,
[LeaveAssetsDesc] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[EstateProvideIncomeYN] [bit] NULL,
[EstateProvideIncomeDesc] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[SufficientInsuranceYN] [bit] NULL,
[InsufficientInsuranceDesc] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[EstateneedsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstatene__Concu__75785BC3] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEstateneedsAudit] ADD CONSTRAINT [PK_TEstateneedsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
