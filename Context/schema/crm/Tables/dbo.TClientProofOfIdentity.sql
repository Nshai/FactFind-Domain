CREATE TABLE [dbo].[TClientProofOfIdentity](
	[ClientProofOfIdentityId] [int] IDENTITY(1,1) NOT NULL,
	[CRMContactId] [int] NOT NULL,
	[Type] [varchar](max) NOT NULL,
	[Number] [varchar](max) NOT NULL,
	[IssuedOn] [datetime] NULL,
	[ExpiresOn] [datetime] NULL,
	[RefCountryId] [int] NOT NULL,
	[RefCountyId] [int] NULL,
	[LastSeenOn] [datetime] NULL,
	[DocumentHref] [varchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[ConcurrencyId] [int] NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_TClientProofOfIdentity] PRIMARY KEY CLUSTERED 
(
	[ClientProofOfIdentityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TClientProofOfIdentity] ADD  CONSTRAINT [DF_TClientProofOfIdentity_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[TClientProofOfIdentity] ADD  CONSTRAINT [DF_TClientProofOfIdentity_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO

ALTER TABLE [dbo].[TClientProofOfIdentity]  WITH CHECK ADD  CONSTRAINT [FK_TClientProofOfIdentity_CRMContactId] FOREIGN KEY([CRMContactId])
REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO

ALTER TABLE [dbo].[TClientProofOfIdentity] CHECK CONSTRAINT [FK_TClientProofOfIdentity_CRMContactId]
GO

ALTER TABLE [dbo].[TClientProofOfIdentity]  WITH CHECK ADD  CONSTRAINT [FK_TClientProofOfIdentity_RefCountryId] FOREIGN KEY([RefCountryId])
REFERENCES [dbo].[TRefCountry] ([RefCountryId])
GO

ALTER TABLE [dbo].[TClientProofOfIdentity] CHECK CONSTRAINT [FK_TClientProofOfIdentity_RefCountryId]
GO

ALTER TABLE [dbo].[TClientProofOfIdentity]  WITH CHECK ADD  CONSTRAINT [FK_TClientProofOfIdentity_RefCountyId] FOREIGN KEY([RefCountyId])
REFERENCES [dbo].[TRefCounty] ([RefCountyId])
GO

ALTER TABLE [dbo].[TClientProofOfIdentity] CHECK CONSTRAINT [FK_TClientProofOfIdentity_RefCountyId]
GO