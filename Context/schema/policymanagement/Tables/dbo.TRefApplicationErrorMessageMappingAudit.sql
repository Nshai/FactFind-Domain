CREATE TABLE [dbo].[TRefApplicationErrorMessageMappingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefApplicationErrorMessageMappingId] [int] NOT NULL,
[RefApplicationId] [int] NULL,
[Code] [nvarchar] (100) NULL,
[ErrorMessage] [nvarchar] (2048) NULL,
[CustomData] [nvarchar] (2048) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefApplicationErrorMessageMappingAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefApplicationErrorMessageMappingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefApplicationErrorMessageMappingAudit] ADD CONSTRAINT [PK_TRefApplicationErrorMessageMappingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO