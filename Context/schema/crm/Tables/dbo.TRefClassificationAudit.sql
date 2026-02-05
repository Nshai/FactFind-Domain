CREATE TABLE [dbo].[TRefClassificationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Colour] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL,
[UserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefClassificationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefClassificationAudit] ADD CONSTRAINT [PK_TRefClassificationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
