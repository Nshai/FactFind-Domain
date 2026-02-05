CREATE TABLE [dbo].[TEmailAddressAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EmailId] [int] NOT NULL,
[Address] [varchar] (300) COLLATE Latin1_General_CI_AS NOT NULL,
[IsCCAddress] [bit] NOT NULL,
[EntityOrganiserActivityId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[EmailAddressId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEmailAddressAudit] ADD CONSTRAINT [PK_TEmailAddressAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
