CREATE TABLE [dbo].[TSpecialProjectsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SpecialProjectsYesNo] [bit] NULL,
[FuturePlans] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[SpecialProjectsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TSpecialP__Concu__2CC890AD] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSpecialProjectsAudit] ADD CONSTRAINT [PK_TSpecialProjectsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
