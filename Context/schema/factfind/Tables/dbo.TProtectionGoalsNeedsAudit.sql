CREATE TABLE [dbo].[TProtectionGoalsNeedsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GoalsAndNeeds] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[ProtectionGoalsNeedsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProtecti__Concu__0856260D] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProtectionGoalsNeedsAudit] ADD CONSTRAINT [PK_TProtectionGoalsNeedsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
