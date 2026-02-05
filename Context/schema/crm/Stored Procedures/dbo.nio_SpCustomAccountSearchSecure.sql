SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SpCustomAccountSearchSecure  
  @TenantId bigint,    
  @CorporateName  varchar(255) = NULL,    
  @FirstName varchar(255) = NULL,    
  @LastName varchar(255) = NULL,  
  @OwnerCRMContactId bigint = 0,
  @AccountTypeId bigint = 0,    
  @PrimaryRef varchar(255) = NULL,    
  @IsIncludeDeleted bit = NULL,    
  @_UserId bigint = 0, 
  @_TopN int = 0    
  
AS        
BEGIN

DECLARE @_OwnerUserId BIGINT
SET @_OwnerUserId = NULL
-- If the Account Owner is passed in then we need to run owner related checks on that...
IF (@OwnerCRMContactId > 0) BEGIN
	SELECT @_OwnerUserId = UserId FROM Administration..TUser WHERE CRMContactId = @OwnerCRMContactId
END
-- end

-- If include deleted is null then set the flag to false
IF ( ISNULL(@IsIncludeDeleted, 0) = 0)
	SET @IsIncludeDeleted  = 0

-- If include deleted is true then set the flag to null so that all records included the deleted ones can show.
IF (@IsIncludeDeleted = 1)
	SET @IsIncludeDeleted  = NULL




-- SuperUser and SuperViewer processing   
-- (Need to do this because NIO does not pass the @_UserId as a negated value for SuperUsers and SuperViewers  
-- A negative Id results in Entity Security being overridden  
IF(@_UserId > 0) BEGIN  
  
 IF EXISTS (SELECT 1 FROM Administration..TUser WHERE UserId = @_UserId AND (SuperUser = 1 OR SuperViewer = 1))   
  SET @_UserId = @_UserId * -1  
  
END  

-- User Rights
DECLARE @RightMask INT
DECLARE @AdvancedMask INT
DECLARE @HasPolicy BIT
SELECT @RightMask = 1, @AdvancedMask = 0, @HasPolicy = 0        
IF @_UserId < 0        
 EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'Account', @RightMask OUTPUT, @AdvancedMask OUTPUT        
     
IF EXISTS         
 (        
 SELECT         
  *          
 FROM         
  Administration..TPolicy P        
  JOIN Administration..TEntity E ON E.EntityId = P.EntityId         
  JOIN Administration..TMembership M ON M.RoleId = P.RoleId        
 WHERE        
  E.Identifier = 'Account'        
  AND M.UserId = @_UserId        
 )        
 SELECT @HasPolicy = 1

-- Limit rows returned?    
IF (@_TopN > 0) SET ROWCOUNT @_TopN    
  
-- START SEARCHING
SELECT        
 A.AccountId AS [AccountId],   
 C.CRMContactId AS [PartyId],       
 C.IndClientId AS [TenantId],         
 CASE        
  WHEN C.CRMContactType = 1 THEN (C.FirstName + ' ' + C.LastName)        
  WHEN C.CRMContactType in (2,3,4) THEN (C.CorporateName)        
 END AS  [AccountName],        

 B.AccountTypeName AS [AccountType],        
 (CUser.FirstName + ' ' + CUser.LastName) AS [AccountOwner],
 ISNULL(C.ExternalReference,'') AS [PrimaryRef],        

  CASE C._OwnerId        
  WHEN ABS(@_UserId) THEN 15        
    ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)        
  END AS [_RightMask],        
  
  CASE C._OwnerId        
  WHEN ABS(@_UserId) THEN 240        
	ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)         
  END AS [_AdvancedMask]        

FROM         
 CRM..TCRMContact C WITH(NOLOCK)      
 JOIN CRM..TAccount A WITH(NOLOCK) ON A.CRMContactId = C.CRMContactId  

 -- Owner Join
 LEFT JOIN Administration..TUser usr WITH(NOLOCK) ON usr.UserId = C._OwnerId
 LEFT JOIN [CRM]..TCRMContact CUser on usr.CRMContactId=CUser.CRMContactId
      
 LEFT JOIN CRM..TAccountType B WITH(NOLOCK) ON B.AccountTypeId = A.AccountTypeId
        
 -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)        
 LEFT JOIN VwAccountKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = C._OwnerId        
 LEFT JOIN VwAccountKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = C.CRMContactId        
WHERE         
	C.IndClientId = @TenantId         
	AND ISNULL(C.InternalContactFG, 0) != 1  
	AND (@IsIncludeDeleted IS NULL OR C.ArchiveFG = @IsIncludeDeleted)
	AND (@AccountTypeId = 0 OR B.AccountTypeId = @AccountTypeId)      
	AND (@CorporateName IS NULL OR C.CorporateName LIKE @CorporateName + '%')        
	AND (@FirstName IS NULL OR C.FirstName LIKE @FirstName + '%')        
	AND (@LastName IS NULL OR C.LastName LIKE @LastName + '%')        
	AND (@PrimaryRef IS NULL OR C.ExternalReference LIKE @PrimaryRef + '%')        
	AND (@_OwnerUserId IS NULL OR C._OwnerId=@_OwnerUserId)

  -- Secure        
 AND (@HasPolicy = 0 OR @_UserId < 0 OR (C._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))        
ORDER BY         
 C.[LastName] DESC, C.[FirstName] DESC       
END
GO
