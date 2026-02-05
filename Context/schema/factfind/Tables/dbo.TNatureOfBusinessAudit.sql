CREATE TABLE [dbo].[TNatureOfBusinessAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NatureOfBusiness] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[NatureOfBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TNatureOf__Concu__45943E77] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNatureOfBusinessAudit] ADD CONSTRAINT [PK_TNatureOfBusinessAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
