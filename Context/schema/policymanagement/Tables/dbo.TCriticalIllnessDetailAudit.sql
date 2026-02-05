CREATE TABLE [dbo].[TCriticalIllnessDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TotalPermanentDisability] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CriticalIllnessCondition] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CoverType] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CriticalIllnessTPDAmount] [decimal] (19, 2) NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[CriticalIllnessDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCriticalIllnessDetailAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCriticalIllnessDetailAudit] ADD CONSTRAINT [PK_TCriticalIllnessDetailAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
