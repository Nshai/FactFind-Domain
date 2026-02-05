CREATE TABLE [dbo].[TYourexpendituresummaryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Amount] [money] NULL,
[Frequency] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[YourexpendituresummaryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TYourexpe__Concu__6265874F] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TYourexpendituresummaryAudit] ADD CONSTRAINT [PK_TYourexpendituresummaryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
