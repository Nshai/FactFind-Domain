CREATE TABLE [dbo].[TClubOfficalsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ClubOfficialName] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ClubOfficialRole] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[SmokerYesNo] [bit] NULL,
[GoodHealth] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[ClubOfficalsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TClubOffi__Concu__6BB9E75F] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClubOfficalsAudit] ADD CONSTRAINT [PK_TClubOfficalsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
