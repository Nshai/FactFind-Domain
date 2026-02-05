CREATE TABLE [dbo].[TLeadStatusHistory]
(
[LeadStatusHistoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[LeadId] [int] NOT NULL,
[LeadStatusId] [int] NOT NULL,
[Notes] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[DateChanged] [datetime] NOT NULL,
[ChangedByUserId] [int] NULL,
[CurrentFG] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TLeadStatusHistory] ADD CONSTRAINT [PK_TLeadStatusHistory] PRIMARY KEY CLUSTERED  ([LeadStatusHistoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TLeadStatusHistory_LeadId_CurrentFG] ON [dbo].[TLeadStatusHistory] ([LeadId], [CurrentFG])
GO
CREATE NONCLUSTERED INDEX [IX_TLeadStatusHistory_LeadStatusId_CurrentFG] ON [dbo].[TLeadStatusHistory] ([LeadStatusId],[CurrentFG]) INCLUDE ([LeadId])
go
CREATE NONCLUSTERED INDEX [IX_TLeadStatusHistory_CurrentFG] ON [dbo].[TLeadStatusHistory] ([CurrentFG]) INCLUDE ([LeadId],[LeadStatusId])
go
CREATE NONCLUSTERED INDEX IX_TLeadStatusHistory_CurrentFG_DateChanged ON [dbo].[TLeadStatusHistory] ([CurrentFG],[DateChanged]) INCLUDE ([LeadId],[LeadStatusId])
GO