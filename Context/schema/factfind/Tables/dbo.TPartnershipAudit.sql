CREATE TABLE [dbo].[TPartnershipAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OtherEmployeesToBeProtected] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PartnershipId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPartners__Concu__6418C597] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPartnershipAudit] ADD CONSTRAINT [PK_TPartnershipAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
