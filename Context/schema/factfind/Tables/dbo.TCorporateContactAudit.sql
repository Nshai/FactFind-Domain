CREATE TABLE [dbo].[TCorporateContactAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ContactId] [int] NOT NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Details] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[isDefault] [bit] NULL,
[CorporateContactId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCorporateContactAudit_ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCorporateContactAudit] ADD CONSTRAINT [PK_TCorporateContactAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
