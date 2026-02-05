create table [dbo].[TPortfolioAttitudeToRiskAudit]
(
  [AuditId] [int] NOT NULL IDENTITY(1, 1),
  [PortfolioAttitudeToRiskId] [int] not null,
  [Code] [varchar](50) not null,
  [PortfolioId] [int] not null,
  [Description] [nvarchar] (255) null,
  [StampAction] [char] (1) NOT NULL,
  [StampDateTime] [datetime] NULL CONSTRAINT [DF_TPortfolioAttitudeToRiskAudit_StampDateTime] DEFAULT (getdate()),
  [StampUser] [varchar] (255) NULL
);
go
alter table [dbo].[TPortfolioAttitudeToRiskAudit] add constraint [PK_TPortfolioAttitudeToRiskAudit] primary key nonclustered ([AuditId]);
go
