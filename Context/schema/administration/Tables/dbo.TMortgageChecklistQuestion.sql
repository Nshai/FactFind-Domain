USE [administration]
GO

/****** Object:  Table [dbo].[TMortgageChecklistQuestion]    Script Date: 03/10/2013 12:48:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TMortgageChecklistQuestion](
	[MortgageChecklistQuestionId] [int] IDENTITY(1,1) NOT NULL,
	[Question] [varchar](max) NOT NULL,
	[MortgageChecklistCategoryId] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
	[IsArchived] [bit] NOT NULL,	
	[TenantId] [int] NOT NULL,
	[ParentQuestionId] [int] NULL,
	[SystemFG] [bit] NULL,
	[ConcurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_TMortgageChecklistQuestion] PRIMARY KEY CLUSTERED 
(
	[MortgageChecklistQuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TMortgageChecklistQuestion] ADD  CONSTRAINT [DF_TMortgageChecklistQuestion_IsArchived]  DEFAULT ((0)) FOR [IsArchived]
GO

ALTER TABLE [dbo].[TMortgageChecklistQuestion] ADD  CONSTRAINT [DF_TMortgageChecklistQuestion_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO


ALTER TABLE [dbo].[TMortgageChecklistQuestion] ADD  CONSTRAINT [DF_TMortgageChecklistQuestion_SystemFG]  DEFAULT ((0)) FOR [SystemFG]
GO

ALTER TABLE [dbo].[TMortgageChecklistQuestion]  WITH CHECK ADD  
CONSTRAINT [FK_TMortgageChecklistQuestion_MortgageChecklistCategoryId_MortgageChecklistCategoryId] FOREIGN KEY([MortgageChecklistCategoryId])
REFERENCES [dbo].[TMortgageChecklistCategory] ([MortgageChecklistCategoryId])
GO

ALTER TABLE [dbo].[TMortgageChecklistQuestion] CHECK CONSTRAINT [FK_TMortgageChecklistQuestion_MortgageChecklistCategoryId_MortgageChecklistCategoryId]
GO



