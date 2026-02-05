CREATE TABLE [dbo].[TLeadAdviserHistory]
(
[LeadAdviserHistoryId] [int] NOT NULL IDENTITY(1, 1),
[LeadId] [int] NOT NULL,
[AdviserId] [int] NOT NULL,
[ChangedByUserId] [int] NOT NULL,
[AssignedDate] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadAdviserHistory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLeadAdviserHistory] ADD CONSTRAINT [PK_TLeadAdviserHistory] PRIMARY KEY CLUSTERED  ([LeadAdviserHistoryId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IDX_TLeadAdviserHistory_AdviserId 
ON [dbo].[TLeadAdviserHistory] ([AdviserId])
INCLUDE ([AssignedDate])
GO
