CREATE TABLE [dbo].[TClubAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[OtherEmployeesToBeProtected] [bit] NULL,
[ClubId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClubAudit_ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClubAudit] ADD CONSTRAINT [PK_TClubAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
