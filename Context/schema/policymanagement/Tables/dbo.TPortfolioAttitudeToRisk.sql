create table [dbo].[TPortfolioAttitudeToRisk]
(
    [PortfolioAttitudeToRiskId] [int] not null identity (1,1),
    [Code] [varchar](50) not null,
	[PortfolioId] [int] not null,
	[Description] [nvarchar] (255) null
);
go
alter table [dbo].[TPortfolioAttitudeToRisk] add constraint [PK_TPortfolioAttitudeToRisk] primary key nonclustered ([PortfolioAttitudeToRiskId]);
go
alter table [dbo].[TPortfolioAttitudeToRisk] 
add constraint [FK_TPortfolioAttitudeToRisk_PortfolioId] 
foreign key ([PortfolioId])
references [dbo].[TPortfolio] ([PortfolioId]);
go
alter table [dbo].[TPortfolioAttitudeToRisk] add constraint [UQ_PotrfolioId_Code] unique([PortfolioId],[Code]);
go

