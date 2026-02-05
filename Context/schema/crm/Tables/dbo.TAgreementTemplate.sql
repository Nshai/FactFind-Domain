CREATE TABLE [dbo].[TAgreementTemplate]
(
    [AgreementTemplateId] [int] NOT NULL IDENTITY (1,1),
    [Name] [nvarchar] (150) COLLATE Latin1_General_CI_AS NOT NULL,
    [Description] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
    [Statement] [nvarchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
    [IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAgreementTemplate_IsArchived] DEFAULT ((0)),
    [GroupId] [int] NOT NULL,
    [GroupName] [nvarchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
    [IncludeSubgroups] [bit] NOT NULL CONSTRAINT [DF_TAgreementTemplate_PropagateToSubgroups] DEFAULT ((0)),
    [TenantId] [int] NOT NULL,
    [CreatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementTemplate_CreatedOn] DEFAULT (getdate()),
    [CreatedBy] [int] NULL,
    [UpdatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementTemplate_UpdatedOn] DEFAULT (getdate()),
    [UpdatedBy] [int] NULL,
    [Version] [int] NULL,
    [BaseTemplateId] [int] NULL
)

GO
ALTER TABLE [dbo].[TAgreementTemplate] ADD CONSTRAINT [PK_TAgreementTemplate] PRIMARY KEY CLUSTERED ([AgreementTemplateId])
GO
ALTER TABLE [dbo].[TAgreementTemplate] ADD CONSTRAINT [FK_TAgreementTemplate_BaseTemplate] FOREIGN KEY ([BaseTemplateId]) REFERENCES [dbo].[TAgreementTemplate] ([AgreementTemplateId])
GO

