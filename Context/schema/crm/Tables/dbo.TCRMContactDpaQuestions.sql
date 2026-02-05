CREATE TABLE [dbo].[TCRMContactDpaQuestions]
(
[CRMContactDpaQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Mail] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestions_Mail] DEFAULT ((0)),
[Telephone] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestions_Telephone] DEFAULT ((0)),
[Email] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestions_Email] DEFAULT ((0)),
[Sms] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestions_Sms] DEFAULT ((0)),
[OtherMail] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestions_OtherMail] DEFAULT ((0)),
[OtherTelephone] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestions_OtherTelephone] DEFAULT ((0)),
[OtherEmail] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestions_OtherEmail] DEFAULT ((0)),
[OtherSms] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestions_OtherSms] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL,
MigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TCRMContactDpaQuestions] ADD CONSTRAINT [PK_TCRMContactDpaQuestions] PRIMARY KEY NONCLUSTERED  ([CRMContactDpaQuestionsId])
GO
CREATE NONCLUSTERED INDEX [IX_TCRMContactDpaQuestions] ON [dbo].[TCRMContactDpaQuestions] ([CRMContactId])
GO
ALTER TABLE [dbo].[TCRMContactDpaQuestions] WITH CHECK ADD CONSTRAINT [FK_TCRMContactDpaQuestions_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
create index IX_TCRMContactDpaQuestions_MigrationRef on TCRMContactDpaQuestions(MigrationRef) 
go 
