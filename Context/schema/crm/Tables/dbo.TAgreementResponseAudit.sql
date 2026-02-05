CREATE TABLE [dbo].[TAgreementResponseAudit]
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [AgreementResponseId] [int] NOT NULL,
    [AgreementId] [int] NOT NULL,
    [Text] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
    [Ordinal] [int] NULL,
    [IsSelected] [bit] NULL,
    [CreatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementResponseAudit_CreatedOn] DEFAULT (getdate()),
    [CreatedBy] [int] NULL,
    [UpdatedOn] [datetime] NULL CONSTRAINT [DF_TAgreementResponseAudit_UpdatedOn] DEFAULT (getdate()),
    [UpdatedBy] [int] NULL,
    [StampAction] [char] (1) NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TAgreementResponseAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) NULL
)

GO
ALTER TABLE [dbo].[TAgreementResponseAudit] ADD CONSTRAINT [PK_TAgreementResponseAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO