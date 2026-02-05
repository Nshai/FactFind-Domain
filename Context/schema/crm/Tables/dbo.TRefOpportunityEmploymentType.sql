CREATE TABLE [dbo].[TRefOpportunityEmploymentType](
	[RefOpportunityEmploymentTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_TRefOpportunityEmploymentType] PRIMARY KEY CLUSTERED 
(
	[RefOpportunityEmploymentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[TRefOpportunityEmploymentType] ADD  CONSTRAINT [DF_TRefOpportunityEmploymentType_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO


