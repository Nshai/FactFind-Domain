CREATE TABLE [dbo].[TDirectorSharesInfoAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AgreementForSharesYesNo] [bit] NULL,
[AgreementForSharesType] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[PowerToPurchaseSharesYesNo] [bit] NULL,
[notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[DirectorSharesInfoId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TDirectorSharesInfoAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDirectorSharesInfoAudit] ADD CONSTRAINT [PK_TDirectorSharesInfoAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
