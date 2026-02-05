CREATE TABLE [dbo].[TProtectionGoalsNeedsQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IsSmoker] [bit] NULL,
[HaveSmoked] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[ProtectionGoalsNeedsQuestionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProtecti__Concu__0A3E6E7F] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProtectionGoalsNeedsQuestionAudit] ADD CONSTRAINT [PK_TProtectionGoalsNeedsQuestionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TProtectionGoalsNeedsQuestionAudit_ProtectionGoalsNeedsQuestionId_ConcurrencyId] ON [dbo].[TProtectionGoalsNeedsQuestionAudit] ([ProtectionGoalsNeedsQuestionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
