CREATE TABLE [dbo].[TIndigoClient]
(
[IndigoClientId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64)  NOT NULL,
[Status] [varchar] (24)  NOT NULL CONSTRAINT [DF_TIndigoClient_Status] DEFAULT ('New'),
[PrimaryContact] [varchar] (128)  NOT NULL,
[ContactId] [int] NULL,
[PhoneNumber] [varchar] (40)  NOT NULL,
[EmailAddress] [varchar] (128)  NOT NULL,
[AdminEmail] [varchar] (128)  NULL,
[PrimaryGroupId] [int] NULL,
[NetworkId] [int] NULL,
[SIB] [varchar] (24)  NULL,
[MCCB] [varchar] (24)  NULL,
[FSA] [varchar] (24)  NULL,
[IOProductType] [varchar] (50)  NOT NULL,
[ExpiryDate] [datetime] NOT NULL,
[AddressLine1] [varchar] (1000)  NOT NULL,
[AddressLine2] [varchar] (1000)  NULL,
[AddressLine3] [varchar] (1000)  NULL,
[AddressLine4] [varchar] (1000)  NULL,
[CityTown] [varchar] (255)  NULL,
[County] [varchar] (255)  NULL,
[Postcode] [varchar] (20)  NOT NULL,
[Country] [varchar] (128)  NOT NULL CONSTRAINT [DF_TIndigoClient_Country] DEFAULT ('UK'),
[IsNetwork] [bit] NOT NULL CONSTRAINT [DF_TIndigoClient_NetOrSupSvcFg] DEFAULT ((0)),
[SupportServiceId] [int] NULL,
[FirmSize] [varchar] (50)  NOT NULL,
[Specialism] [varchar] (128)  NOT NULL,
[OtherSpecialism] [varchar] (128)  NULL,
[SupportLevel] [varchar] (50)  NOT NULL,
[EmailSupOptn] [varchar] (50)  NOT NULL,
[SupportEmail] [varchar] (128)  NOT NULL,
[TelSupOptn] [varchar] (50)  NOT NULL,
[SupportTelephone] [varchar] (40)  NOT NULL,
[AllowPasswordEmail] [bit] NOT NULL CONSTRAINT [DF_TIndigoClient_AllowPasswordEmail] DEFAULT ((1)),
[SessionTimeout] [int] NOT NULL,
[LicenceType] [varchar] (50)  NOT NULL,
[MaxConUsers] [int] NULL,
[MaxULAGCount] [int] NULL,
[UADRestriction] [bit] NOT NULL,
[MaxULADCount] [int] NULL,
[AdviserCountRestrict] [bit] NOT NULL,
[MaxAdviserCount] [int] NULL,
[MaxFinancialPlanningUsers] [int] NULL,
[EmailFormat] [varchar] (128)  NULL,
[UserNameFormat] [varchar] (24)  NULL,
[NTDomain] [varchar] (255)  NULL,
[IsIndependent] [bit] NOT NULL CONSTRAINT [DF_TIndigoClient_IsIndependent] DEFAULT ((1)),
[BrandDescriptor] [varchar] (64)  NULL,
[ServiceLevel] [int] NULL,
[HostingFg] [bit] NOT NULL CONSTRAINT [DF_TIndigoClient_HostingFg] DEFAULT ((0)),
[CaseLoggingOption] [int] NOT NULL CONSTRAINT [DF_TIndigoClient_CaseLoggingOption] DEFAULT ((0)),
[Guid] [uniqueidentifier] NULL CONSTRAINT [DF_TIndigoClient_Guid] DEFAULT (newid()),
[RefEnvironmentId] [int] NULL,
[IsPortfolioConstructionProvider] [bit] NOT NULL CONSTRAINT [DF_TIndigoClient_IsPortfolioConstructionProvider] DEFAULT ((0)),
[IsAuthorProvider] [bit] NOT NULL CONSTRAINT [DF_TIndigoClient_IsAuthorProvider] DEFAULT ((0)),
[IsAtrProvider] [bit] NOT NULL CONSTRAINT [DF_TIndigoClient_IsAtrProvider] DEFAULT ((0)),
[MortgageBenchLicenceCount] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndigoClient_ConcurrencyId] DEFAULT ((1)),
[MaxOutlookExtensionUsers] [int] NULL,
[MaxAdvisaCentaCoreUsers] [int] NULL,
[MaxAdvisaCentaCorePlusLifetimePlannerUsers] [int] NULL,
[MaxFeAnalyticsCoreUsers] [int] NULL,
[MaxVoyantUsers] [int] NULL,
[MaxAdvisaCentaFullUsers] [int] NULL,
[MaxAdvisaCentaFullPlusLifetimePlannerUsers] [int] NULL,
[MaxPensionFreedomPlannerUsers] [int] NULL,
[MaxSolutionBuilderUsers] [int] NULL,
[LEI] [NVARCHAR](20) NULL,
[RefTenantTypeId] [int] NULL
)
GO
ALTER TABLE [dbo].[TIndigoClient] ADD CONSTRAINT [PK_TIndigoClient_IndigoClientId] PRIMARY KEY CLUSTERED  ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TIndigoClient] ON [dbo].[TIndigoClient] ([PrimaryGroupId])
GO
ALTER TABLE [dbo].[TIndigoClient] WITH CHECK ADD CONSTRAINT [FK_TIndigoClient_TIndigoClient] FOREIGN KEY ([NetworkId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TIndigoClient_NetworkId] ON [dbo].[TIndigoClient] ([NetworkId])
GO
ALTER TABLE [dbo].[TIndigoClient] WITH CHECK ADD CONSTRAINT [FK_TIndigoClient_PrimaryGroupId_GroupId] FOREIGN KEY ([PrimaryGroupId]) REFERENCES [dbo].[TGroup] ([GroupId])
GO
ALTER TABLE [dbo].[TIndigoClient] WITH CHECK ADD CONSTRAINT [FK_TIndigoClient_TRefEnvironment] FOREIGN KEY ([RefEnvironmentId]) REFERENCES [dbo].[TRefEnvironment] ([RefEnvironmentId])
GO
ALTER TABLE [dbo].[TIndigoClient] WITH CHECK ADD CONSTRAINT [FK_TIndigoClient_ServiceLevel_ServiceLevelId] FOREIGN KEY ([ServiceLevel]) REFERENCES [dbo].[TServiceLevel] ([ServiceLevelId])
GO
CREATE NONCLUSTERED INDEX IX_TindigoClient_Guid ON [dbo].[TIndigoClient] ([Guid]) INCLUDE ([IndigoClientId])
GO
