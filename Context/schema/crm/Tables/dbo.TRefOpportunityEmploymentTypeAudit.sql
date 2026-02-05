CREATE TABLE [dbo].[TRefOpportunityEmploymentTypeAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[RefOpportunityEmploymentTypeId] [int] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
 CONSTRAINT [PK_TRefOpportunityEmploymentTypeAudit] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TRefOpportunityEmploymentTypeAudit] ADD  CONSTRAINT [DF_TRefOpportunityEmploymentTypeAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]
GO


