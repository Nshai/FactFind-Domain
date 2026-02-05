create view [dbo].[vPV_ProviderToBeReviewed]
as
select RefProdProviderId, Name from vprovider where name in 
('AXA',
'Royal & Sun Alliance',
'INVESTEC',
'Scottish Amicable',
'Allied Dunbar',
'Sun Life',
'Eagle Star',
'Selestia',
'Old Mutual'
)
go