CREATE TABLE [dbo].[TAgreementTemplateAudit]
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [AgreementTemplateId] [int] NOT NULL,
    [Name] [nvarchar] (150) COLLATE Latin1_General_CI_AS NOT NULL,
    [Description] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
    [Statement] [nvarchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
    [IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAgreementTemplateAudit_IsArchived] DEFAULT ((0)),
    [GroupId] [int] NOT NULL,
    [GroupName] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
    [IncludeSubgroups] [bit] NOT NULL CONSTRAINT [DF_TAgreementTemplateAudit_PropagateToSubgroups] DEFAULT ((0)),
    [TenantId] [int] NOT NULL,
    [CreatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementTemplateAudit_CreatedOn] DEFAULT (getdate()),
    [CreatedBy] [int] NULL,
    [UpdatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementTemplateAudit_UpdatedOn] DEFAULT (getdate()),
    [UpdatedBy] [int] NULL,
    [Version] [int] NULL,
    [BaseTemplateId] [int] NULL,
    [StampAction] [char] (1) NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TAgreementTemplateAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) NULL
)

GO
ALTER TABLE [dbo].[TAgreementTemplateAudit] ADD CONSTRAINT [PK_TAgreementTemplateAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO