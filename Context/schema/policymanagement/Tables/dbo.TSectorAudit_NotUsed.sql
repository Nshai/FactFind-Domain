CREATE TABLE [dbo].[TSectorAudit_NotUsed]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FundTypeId] [int] NOT NULL,
[FeedId] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_TSectorAudit_UpdatedDate] DEFAULT (getdate()),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TSectorAudit_CreatedDate] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSectorAudit_ConcurrencyId] DEFAULT ((1)),
[SectorId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSectorAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSectorAudit_NotUsed] ADD CONSTRAINT [PK_TSectorAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
