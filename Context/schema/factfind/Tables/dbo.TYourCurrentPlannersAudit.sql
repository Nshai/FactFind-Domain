CREATE TABLE [dbo].[TYourCurrentPlannersAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Type] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ContactNumber] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Address] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[YourCurrentPlannersId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TYourCurr__Concu__3FDB6521] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TYourCurrentPlannersAudit] ADD CONSTRAINT [PK_TYourCurrentPlannersAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
