CREATE TABLE [dbo].[TAgreementTemplateResponseAudit]
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [AgreementTemplateResponseId] [int] NOT NULL,
    [AgreementTemplateId] [int] NOT NULL,
    [Text] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
    [Ordinal] [int] NOT NULL,
    [CreatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementTemplateResponseAudit_CreatedOn] DEFAULT (getdate()),
    [CreatedBy] [int] NULL,
    [UpdatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementTemplateResponseAudit_UpdatedOn] DEFAULT (getdate()),
    [UpdatedBy] [int] NULL,
    [StampAction] [char] (1) NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TAgreementTemplateResponseAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) NULL
)

GO
ALTER TABLE [dbo].[TAgreementTemplateResponseAudit] ADD CONSTRAINT [PK_TAgreementTemplateResponseAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO