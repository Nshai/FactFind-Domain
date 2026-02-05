CREATE TABLE [dbo].[TPropertiesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Type] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[LivingHere] [bit] NULL,
[Adviser] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AdviserId] [int] NULL,
[CRMContactId] [int] NOT NULL,
[PropertiesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProperti__Concu__4B8221F7] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPropertiesAudit] ADD CONSTRAINT [PK_TPropertiesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
