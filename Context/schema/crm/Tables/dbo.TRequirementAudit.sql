SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE TABLE [dbo].[TRequirementAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](100) NOT NULL,
	[PrimaryPartyId] [int] NOT NULL,
	[SecondaryPartyId] [int] NULL,
	[TenantId] [int] NOT NULL,
	[MortgageOpportunityId] [int] NULL,
	[ObjectiveId] [int] NULL,
	[RequirementId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRequirementAudit_StampDateTime]  DEFAULT (getdate()),
	[StampUser] [varchar](255) NULL
 CONSTRAINT [PK_TRequirementAudit] PRIMARY KEY NONCLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [IDX_TRequirementAudit_Type_TenantId] ON [dbo].[TRequirementAudit] ([Type], [TenantId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRequirementAudit_MortgageOpportunityId] ON [dbo].[TRequirementAudit] ([MortgageOpportunityId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRequirementAudit_ObjectiveId] ON [dbo].[TRequirementAudit] ([ObjectiveId]) WITH (FILLFACTOR=80)
GO



