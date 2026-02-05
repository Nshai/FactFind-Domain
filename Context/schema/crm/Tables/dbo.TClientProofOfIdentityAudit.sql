CREATE TABLE [dbo].[TClientProofOfIdentityAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[ClientProofOfIdentityId] [int] NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
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
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_TClientProofOfIdentityAudit_AuditId] PRIMARY KEY NONCLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TClientProofOfIdentityAudit] ADD  CONSTRAINT [DF_TClientProofOfIdentityAudit_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO

ALTER TABLE [dbo].[TClientProofOfIdentityAudit] ADD  CONSTRAINT [DF_TClientProofOfIdentityAudit_StampDateTime]  DEFAULT (getdate()) FOR [StampDateTime]
GO