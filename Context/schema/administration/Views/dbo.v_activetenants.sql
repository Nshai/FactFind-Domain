CREATE view [dbo].[v_activetenants]  
as  
select 
    @@servername as ServerName, 
    A.IndigoClientId, 
    max(B.Identifier) as Name, 
    max(B.Postcode) as Postcode, 
    sum(A.MaxULAGCount) as LicenseCount, 
    max(C.UserCount) as UserCount, 
    max(E.[Full]) as LC_Full, 
    max(E.Introducer) as LC_Introducer, 
    max(E.[Master]) as LC_Master, 
    max(E.Mortgage) as LC_Mortgage, 
    max(E.MortgageAdmin) as LC_MortgageAdmin, 
    max(E.Workflow) as LC_Workflow, 
    min(B1.Identifier) as Network, 
    min(B.Guid) as guid, 
    min(B.FSA) as FSA  
from Administration.dbo.TIndigoClientLicense A  
join Administration.dbo.TIndigoClient B on A.IndigoClientId = B.IndigoClientId  
left join Administration.dbo.TIndigoClient B1 on B.NetworkId = B1.IndigoClientId  
join 
(
    select IndigoClientId,
    count(1) as UserCount 
    from Administration.dbo.TUser 
    where [Status] like 'Access Granted%logged%' 
    and RefUserTypeId not in (2,5)  
    group by IndigoClientId
) C on A.IndigoClientId = C.IndigoClientId  
join 
(
    select IndigoClientId, 
    [Full] as [Full], 
    [Introducer] as Introducer,  
    [Master] as [Master], 
    [Mortgage] as Mortgage, 
    [MortgageAdmin] as MortgageAdmin, 
    [Workflow] as Workflow   
    from   
    (
        select B.IndigoClientId,
        case when LicenseTypeName = 'Lighthouse' then 'Full' else LicenseTypeName end as  LicenseTypeName,
        sum(MaxULAGCount) as MaxULAGCount 
        from TRefLicenseType A 
        join TIndigoClientLicense B on A.RefLicenseTypeId = B.LicenseTypeId 
        group by B.IndigoClientId,LicenseTypeName
    ) p  
    PIVOT  
    (
        sum (MaxULAGCount)
	FOR LicenseTypeName IN ( [full], [Introducer], [Lighthouse], [Master], [Mortgage], [MortgageAdmin], [Workflow] )
    ) AS pvt
) E on B.IndigoClientId = E.IndigoClientId  
where 
(
    B.Identifier not like '%Intelliflo%' 
    and B.Identifier not like '%training%' 
    and B.Identifier not like '%UAT%' 
    and B.Identifier not like '%TEST%' 
    and B.Identifier not like '%TST%'
    and B.Identifier not like '%tcslave%'
    and B.Identifier not like '%Backup%'
    and B.Identifier not like '%Removed%'  
    and B.Status  = 'active' 
    and B.Identifier not like '%Honister%' 
    and B.Identifier not like '%Implementation%' 
    and B.EmailAddress not like '%intelliflo.com%'
)   
group by A.IndigoClientId  