CREATE TABLE [dbo].[TCRMContactDpaQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[Mail] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestionsAudit_Mail] DEFAULT ((0)),
[Telephone] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestionsAudit_Telephone] DEFAULT ((0)),
[Email] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestionsAudit_Email] DEFAULT ((0)),
[Sms] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestionsAudit_Sms] DEFAULT ((0)),
[OtherMail] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestionsAudit_OtherMail] DEFAULT ((0)),
[OtherTelephone] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestionsAudit_OtherTelephone] DEFAULT ((0)),
[OtherEmail] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestionsAudit_OtherEmail] DEFAULT ((0)),
[OtherSms] [bit] NOT NULL CONSTRAINT [DF_TCRMContactDpaQuestionsAudit_OtherSms] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL,
[CRMContactDpaQuestionsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCRMContactDpaQuestionsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
MigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TCRMContactDpaQuestionsAudit] ADD CONSTRAINT [PK_TCRMContactDpaQuestionsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
