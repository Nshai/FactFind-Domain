CREATE TABLE [dbo].[TAgreementResponse]
(
    [AgreementResponseId] [int] NOT NULL IDENTITY (1,1),
    [AgreementId] [int] NOT NULL,
    [Text] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
    [Ordinal] [int] NULL,
    [IsSelected] [bit] NULL,
    [CreatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementResponse_CreatedOn] DEFAULT (getdate()),
    [CreatedBy] [int] NULL,
    [UpdatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementResponse_UpdatedOn] DEFAULT (getdate()),
    [UpdatedBy] [int] NULL
)

GO
ALTER TABLE [dbo].[TAgreementResponse] ADD CONSTRAINT [PK_TAgreementResponse] PRIMARY KEY CLUSTERED ([AgreementResponseId])
GO
ALTER TABLE [dbo].[TAgreementResponse] ADD CONSTRAINT [FK_TAgreementResponse_AgreementId] FOREIGN KEY ([AgreementId]) REFERENCES [dbo].[TAgreement](AgreementId)
GO