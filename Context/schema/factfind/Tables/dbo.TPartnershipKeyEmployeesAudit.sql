CREATE TABLE [dbo].[TPartnershipKeyEmployeesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RolesDuties] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[Smoker] [bit] NULL,
[GoodHealth] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PartnershipKeyEmployeesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPartners__Concu__66010E09] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPartnershipKeyEmployeesAudit] ADD CONSTRAINT [PK_TPartnershipKeyEmployeesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
