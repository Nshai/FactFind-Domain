CREATE TABLE [dbo].[TProtectionNextStepsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NextSteps] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[ProtectionNextStepsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProtecti__Concu__0C26B6F1] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProtectionNextStepsAudit] ADD CONSTRAINT [PK_TProtectionNextStepsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
