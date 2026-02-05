CREATE TABLE [dbo].[TAgreementAudit]
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [AgreementId] [int] NOT NULL,
    [AgreementTemplateId] [int] NOT NULL,
    [CrmContactId] [int],
    [Statement] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
    [Status] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
    [CreatedAt] [datetime],
    [CompletedAt] [datetime],
    [ExpiresOn] [datetime],
    [TenantId] [int] NOT NULL,
    [CreatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementAudit_CreatedOn] DEFAULT (getdate()),
    [CreatedBy] [int] NULL,
    [UpdatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementAudit_UpdatedOn] DEFAULT (getdate()),
    [UpdatedBy] [int] NULL,
    [StampAction] [char] (1) NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TAgreementAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) NULL
)

GO
ALTER TABLE [dbo].[TAgreementAudit] ADD CONSTRAINT [PK_TAgreementAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO