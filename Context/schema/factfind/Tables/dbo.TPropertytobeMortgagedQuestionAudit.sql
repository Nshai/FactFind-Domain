CREATE TABLE [dbo].[TPropertytobeMortgagedQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[iscurrentresidence] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPropertytobeMortgagedQuestionAudit_ConcurrencyId] DEFAULT ((1)),
[PropertytobeMortgagedQuestionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPropertytobeMortgagedQuestionAudit] ADD CONSTRAINT [PK_TPropertytobeMortgagedQuestionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
