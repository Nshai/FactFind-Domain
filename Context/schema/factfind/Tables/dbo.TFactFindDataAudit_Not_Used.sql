CREATE TABLE [dbo].[TFactFindDataAudit_Not_Used]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FactFindEntityId] [int] NOT NULL,
[CrmContactId] [int] NOT NULL,
[XmlData] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[IsJoint] [bit] NOT NULL CONSTRAINT [DF_TFactFindDataAudit_IsJoint] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindDataAudit_ConcurrencyId] DEFAULT ((1)),
[FactFindDataId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFactFindDataAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFactFindDataAudit_Not_Used] ADD CONSTRAINT [PK_TFactFindDataAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
