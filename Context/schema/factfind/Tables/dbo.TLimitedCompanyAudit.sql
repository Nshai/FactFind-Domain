CREATE TABLE [dbo].[TLimitedCompanyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OtherEmployeesToBeProtected] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[LimitedCompanyId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TLimitedC__Concu__6DA22FD1] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLimitedCompanyAudit] ADD CONSTRAINT [PK_TLimitedCompanyAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
