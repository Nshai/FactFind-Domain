CREATE TABLE [dbo].[TAgreementTemplateResponse]
(
    [AgreementTemplateResponseId] [int] NOT NULL IDENTITY (1,1),
    [AgreementTemplateId] [int] NOT NULL,
    [Text] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
    [Ordinal] [int] NOT NULL,
    [CreatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementTemplateResponse_CreatedOn] DEFAULT (getdate()),
    [CreatedBy] [int] NULL,
    [UpdatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementTemplateResponse_UpdatedOn] DEFAULT (getdate()),
    [UpdatedBy] [int] NULL
)

GO
ALTER TABLE [dbo].[TAgreementTemplateResponse] ADD CONSTRAINT [PK_TAgreementTemplateResponse] PRIMARY KEY CLUSTERED ([AgreementTemplateResponseId])
GO
ALTER TABLE [dbo].[TAgreementTemplateResponse] ADD CONSTRAINT [FK_AgreementTemplate_AgreementTemplateId] FOREIGN KEY ([AgreementTemplateId]) REFERENCES [dbo].[TAgreementTemplate](AgreementTemplateId)
GO