CREATE TABLE [dbo].[TAgreement]
(
    [AgreementId] [int] NOT NULL IDENTITY (1,1),
    [AgreementTemplateId] [int] NOT NULL,
    [CrmContactId] [int],
    [Statement] [nvarchar] (500) COLLATE Latin1_General_CI_AS NULL,
    [Status] [varchar] (25) COLLATE Latin1_General_CI_AS NULL,
    [CreatedAt] [datetime],
    [CompletedAt] [datetime],
    [ExpiresOn] [datetime],
    [TenantId] [int] NOT NULL,
    [CreatedOn] [datetime] NULL CONSTRAINT [DF_TAgreement_CreatedOn] DEFAULT (getdate()),
    [CreatedBy] [int] NULL,
    [UpdatedOn] [datetime] NULL CONSTRAINT [DF_TAgreement_UpdatedOn] DEFAULT (getdate()),
    [UpdatedBy] [int] NULL
)

GO
ALTER TABLE [dbo].[TAgreement] ADD CONSTRAINT [PK_TAgreement] PRIMARY KEY CLUSTERED ([AgreementId])
GO
ALTER TABLE [dbo].[TAgreement] ADD CONSTRAINT [FK_TAgreement_AgreementTemplateId] FOREIGN KEY ([AgreementTemplateId]) REFERENCES [dbo].[TAgreementTemplate](AgreementTemplateId)
GO