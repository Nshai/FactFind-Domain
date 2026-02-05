CREATE TABLE [dbo].[TPractitionerTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Description] [varchar] (255) NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TPractitionerTypeAudit_CreatedDate] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPractitionerTypeAudit_ConcurrencyId] DEFAULT ((1)),
[PractitionerTypeId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPractitionerTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TPractitionerTypeAudit] ADD CONSTRAINT [PK_TPractitionerTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
