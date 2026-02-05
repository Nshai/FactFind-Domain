CREATE TABLE [dbo].[TRefNationality2RefCountryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefNationality2RefCountryId] [int] NOT NULL,
[RefNationalityId] [int] NOT NULL,
[RefCountryId] [int] NOT NULL,
[Descriptor] [nvarchar] (255) COLLATE Latin1_General_CI_AS  NOT NULL,
[ISOAlpha2Code] [nvarchar] (10) COLLATE Latin1_General_CI_AS  NULL,
[ISOAlpha3Code] [nvarchar] (10) COLLATE Latin1_General_CI_AS  NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefNationality2RefCountryAudit_ConcurrencyId_2__54] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefNationality2RefCountryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
)
GO
ALTER TABLE [dbo].[TRefNationality2RefCountryAudit] ADD CONSTRAINT [PK_TRefNationality2RefCountryAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO

