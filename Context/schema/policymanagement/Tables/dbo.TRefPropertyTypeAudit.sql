CREATE TABLE [dbo].[TRefPropertyTypeAudit]
(
[Audit] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[RefPropertyTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPropertyTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPropertyTypeAudit] ADD CONSTRAINT [PK_TRefPropertyTypeAudit] PRIMARY KEY NONCLUSTERED  ([Audit])
GO
