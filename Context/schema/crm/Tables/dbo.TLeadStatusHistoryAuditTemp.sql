CREATE TABLE [dbo].[TLeadStatusHistoryAuditTemp]
(
[AuditId] [int] NOT NULL,
[LeadId] [int] NOT NULL,
[LeadStatusId] [int] NOT NULL,
[Notes] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[DateChanged] [datetime] NOT NULL,
[ChangedByUserId] [int] NULL,
[CurrentFG] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[LeadStatusHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
