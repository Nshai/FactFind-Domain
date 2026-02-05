CREATE TABLE [dbo].[TExWebQuoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PractitionerId] [int] NOT NULL,
[CRMContactId1] [int] NULL,
[CRMContactId2] [int] NULL,
[Basis] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Date] [datetime] NOT NULL,
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Type] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ServiceType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Reference] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Request] [text] COLLATE Latin1_General_CI_AS NOT NULL,
[Response] [text] COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExWebQuoteAudit_ConcurrencyId] DEFAULT ((1)),
[ExWebQuoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExWebQuoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TExWebQuoteAudit] ADD CONSTRAINT [PK_TExWebQuoteAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
