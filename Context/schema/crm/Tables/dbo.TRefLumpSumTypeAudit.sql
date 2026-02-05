CREATE TABLE [dbo].[TRefLumpSumTypeAudit](
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[RefLumpSumTypeId] [int] NOT NULL,
	[TypeName] [varchar](50) NOT NULL,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefLumpSumTypeAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)

ALTER TABLE [dbo].[TRefLumpSumTypeAudit] ADD CONSTRAINT [PK_TRefLumpSumTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO