USE [administration]
GO

/****** Object:  Table [dbo].[TMortgageChecklistQuestionAudit]    Script Date: 21/10/2013 12:54:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TMortgageChecklistQuestionAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[MortgageChecklistQuestionId] [int] NOT NULL,
	[Question] [varchar](max) NOT NULL,
	[MortgageChecklistCategoryId] [int] NOT NULL,
	[Ordinal] [int] NULL,
	[IsArchived] [bit] NOT NULL,	
	[TenantId] [int] NOT NULL,
	[ParentQuestionId] [int] NULL,
	[SystemFG] [bit] NULL,
	[ConcurrencyId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL	
 CONSTRAINT [PK_TMortgageChecklistQuestionAudit] PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TMortgageChecklistQuestionAudit] ADD  CONSTRAINT [DF_TMortgageChecklistQuestionAudit_IsArchived]  DEFAULT ((0)) FOR [IsArchived]
GO

ALTER TABLE [dbo].[TMortgageChecklistQuestionAudit] ADD  CONSTRAINT [DF_TMortgageChecklistQuestionAudit_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO

ALTER TABLE [dbo].[TMortgageChecklistQuestionAudit] ADD  CONSTRAINT [DF_TMortgageChecklistQuestionAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]
GO


