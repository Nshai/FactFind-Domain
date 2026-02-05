CREATE TABLE [dbo].[TAtrRetirementAuditTemp]
(
[AuditId] [int] NOT NULL,
[AtrQuestionId] [int] NOT NULL,
[AtrAnswerId] [int] NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NULL,
[AtrRetirementId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
