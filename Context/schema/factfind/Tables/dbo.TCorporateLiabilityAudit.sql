CREATE TABLE [dbo].[TCorporateLiabilityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LiabilityType] [varchar] (256) COLLATE Latin1_General_CI_AS NULL,
[Nature] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[OutstandingAmount] [money] NULL,
[RepaymentMethod] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RepaymentDate] [datetime] NULL,
[LiabilityName] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[CorporateLiabilityId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCorporateLiabilityAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCorporateLiabilityAudit] ADD CONSTRAINT [PK_TCorporateLiabilityAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
