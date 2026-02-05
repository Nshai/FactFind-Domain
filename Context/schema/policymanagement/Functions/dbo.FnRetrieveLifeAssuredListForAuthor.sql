SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnRetrieveLifeAssuredListForAuthor](@PolicyBusinessId bigint)  
RETURNS varchar(1000)  
AS  
BEGIN  
 DECLARE @LifeAssuredList varchar(1000)  
 DECLARE @LifeAssuredCount int, @Delimiter varchar(3)  
   
 SET @LifeAssuredCount = (  
	select COUNT(1)
	from TPolicyBusiness pb
	join TProtection p on p.PolicyBusinessId = pb.PolicyBusinessId
	join TAssuredLife al on al.ProtectionId = p.ProtectionId
	join crm..TCRMContact c on c.CRMContactId = al.PartyId
	where pb.PolicyBusinessId = @PolicyBusinessId  
 )  
   
   
 if @LifeAssuredCount > 2   
  set @Delimiter = ', '  
 else  
  set @Delimiter = ' & '  
    
 SELECT @LifeAssuredList = isnull(@LifeAssuredList + @Delimiter,'') + IsNull(c.FirstName, '') + ' ' + IsNull(c.LastName, '') + isNull(c.CorporateName, '')  
	from TPolicyBusiness pb
	join TProtection p on p.PolicyBusinessId = pb.PolicyBusinessId
	join TAssuredLife al on al.ProtectionId = p.ProtectionId
	join crm..TCRMContact c on c.CRMContactId = al.PartyId
	where pb.PolicyBusinessId = @PolicyBusinessId
  
   
 RETURN (@LifeAssuredList)  
 
END  
  
  
  
  
  