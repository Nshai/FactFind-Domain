CREATE TABLE [dbo].[TCorporateOperationalAddressAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[isSameAsRegistered] [bit] NULL,
[ContactId] [int] NULL,
[CorporateOperationalAddressId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCorporateOperationalAddressAudit_ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCorporateOperationalAddressAudit] ADD CONSTRAINT [PK_TCorporateOperationalAddressAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
