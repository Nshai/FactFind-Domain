create view [dbo].[vPV_ProviderToBeSetup]
as
select RefProdProviderId, Name from vprovider where name in 
('Invesco Perpetual',
'Jupiter',
'UNUM',
'MetLife',
'Just Retirement',
'Investec Bank',
'Octopus Investments Ltd',
'Alliance Trust Pensions Limited',
'Premier',
'SEI Investments',
'Alliance Trust Savings Ltd.',
'Alliance Trust',
'Cazenove',
'Praemium',
'Saltus')
go