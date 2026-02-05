CREATE TABLE [dbo].[TPersonExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PersonExtId] [int] NOT NULL,
[PersonId] [int] NOT NULL,
[HealthNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[MedicalConditionNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[HasOtherConsiderations] [bit] NULL,
[OtherConsiderationsNotes] [varchar](500) NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPersonExtAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPersonExtAudit] ADD CONSTRAINT [PK_TPersonExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=90)
GO
