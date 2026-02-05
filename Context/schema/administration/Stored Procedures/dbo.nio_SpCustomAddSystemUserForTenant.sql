SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[nio_SpCustomAddSystemUserForTenant]
		@TenantId bigint,
		@Timezone varchar(32) = 'Europe/London'
AS
      
BEGIN

BEGIN TRANSACTION
	  
DECLARE @PersonId BIGINT
DECLARE @CRMContactId BIGINT
DECLARE @UserId BIGINT
DECLARE @RefUserTypeId BIGINT

SET @RefUserTypeId = 5

-- ######################	Step 1 - INSERT INTO TPerson	######################
INSERT INTO CRM..TPerson
           (FirstName, LastName,ArchiveFG,IndClientId)
SELECT ('System'+CAST(@TenantId AS VARCHAR(100))), 'User', 0, @TenantId
SELECT @PersonId = SCOPE_IDENTITY()
-- INSERT INTO TPersonAudit
INSERT INTO CRM..TPersonAudit
           (FirstName,LastName,DOB, ArchiveFG,IndClientId,ConcurrencyId,PersonId,StampAction,StampDateTime,StampUser)
SELECT P.FirstName, P.LastName, P.DOB, P.ArchiveFG, P.IndClientId,P.ConcurrencyId, P.PersonId, 'C', GETDATE(), '999999' 
FROM CRM..TPerson P
WHERE P.PersonId = @PersonId


-- ######################	Step 2 - INSERT INTO TCRMContact	######################
INSERT INTO CRM..TCRMContact
           (PersonId, ArchiveFg, LastName, FirstName, OriginalAdviserCRMId, CurrentAdviserCRMId, 
           CRMContactType, IndClientId,InternalContactFG,CreatedDate)
SELECT P.PersonId,0, P.FirstName, P.LastName, 0,0,1, @TenantId, 1, GETDATE()
FROM CRM..TPerson P
WHERE P.PersonId = @PersonId
SELECT @CRMContactId = SCOPE_IDENTITY()
-- INSERT INTO TCRMContactAudit
INSERT INTO CRM..TCRMContactAudit
           (PersonId, ArchiveFg, LastName, FirstName, OriginalAdviserCRMId, CurrentAdviserCRMId, 
           CRMContactType, IndClientId,InternalContactFG,CreatedDate,ConcurrencyId,CRMContactId,StampAction,StampDateTime,StampUser)
SELECT C.PersonId, C.ArchiveFg, C.LastName, C.FirstName, C.OriginalAdviserCRMId, C.CurrentAdviserCRMId, 
           C.CRMContactType, C.IndClientId, C.InternalContactFG, C.CreatedDate, C.ConcurrencyId, C.CRMContactId, 
		  'C', GETDATE(), '999999'
FROM CRM..TCRMContact C
WHERE C.CRMContactId = @CRMContactId
	

-- ######################	Step 3 - INSERT INTO TRefUserType	######################
IF NOT EXISTS (SELECT 1 FROM TRefUserType WHERE RefUserTypeId = @RefUserTypeId)
BEGIN
	SET IDENTITY_INSERT TRefUserType ON
	INSERT INTO TRefUserType(RefUserTypeId,Identifier,Url)
				VALUES (@RefUserTypeId,'System User','')

	-- INSERT INTO TRefUserTypeAudit
	INSERT INTO TRefUserTypeAudit
			   (Identifier,Url,ConcurrencyId,RefUserTypeId,StampAction,StampDateTime,StampUser)
		SELECT
			   Identifier,Url,ConcurrencyId,RefUserTypeId,'C',GETDATE(),'999999'
		FROM TRefUserType
		WHERE RefUserTypeId = @RefUserTypeId
	SET IDENTITY_INSERT TRefUserType OFF
END	
	
-- ######################	Step 4 - INSERT INTO TUser	######################
INSERT INTO TUser
           (Identifier,[Password],Email,[Status],GroupId,SuperUser,SuperViewer,FinancialPlanningAccess,WelcomePage
           ,Reference,CRMContactId,IndigoClientId,ActiveRole,RefUserTypeId,Timezone)
SELECT 'System' + CAST(@TenantId AS VARCHAR(100)), Null,'','Access Granted - Not Logged In',
		G.GroupId,1,1,1,'goto,news,links','',@CRMContactId, @TenantId,R.RoleId,@RefUserTypeId,@Timezone
FROM  TGrouping GR
	INNER JOIN TGroup G ON
		G.GroupingId = GR.GroupingId 
		
	LEFT JOIN (SELECT MIN(RoleId) AS RoleId, GroupingId
				FROM TRole
				GROUP BY GroupingId) AS R
	ON R.GroupingId = G.GroupingId
		
WHERE 
	GR.IndigoClientId = @TenantId
	AND GR.ParentId IS NULL
	AND G.ParentId IS NULL	
SELECT @UserId = SCOPE_IDENTITY()
	
--	INSERT INTO TUserAudit	
INSERT INTO TUserAudit
           (Identifier,[Password],Email,[Status],GroupId,SuperUser,SuperViewer,FinancialPlanningAccess,WelcomePage,Reference
           ,CRMContactId,IndigoClientId,ActiveRole,RefUserTypeId,[Guid], ConcurrencyId,UserId,StampAction,StampDateTime,StampUser,Timezone)
SELECT Identifier,[Password],Email,[Status],GroupId,SuperUser,SuperViewer,FinancialPlanningAccess,WelcomePage
           ,Reference,CRMContactId,IndigoClientId,ActiveRole,RefUserTypeId,[Guid],
		   ConcurrencyId, UserId,'C',GETDATE(),'999999',Timezone 
FROM TUser 
	WHERE UserId = @UserId

-- ######################	Step 5 - INSERT INTO TUserCombined	######################
INSERT INTO TUserCombined
           ([Guid],UserId,Identifier,IndigoClientId,IndigoClientGuid)
SELECT U.[Guid], U.UserId, U.Identifier, U.IndigoClientId, I.[Guid]
FROM TUser U
INNER JOIN TIndigoClient I
	ON I.IndigoClientId = U.IndigoClientId
WHERE U.UserId = @UserId

-- INSERT INTO TUserCombinedAudit
INSERT INTO TUserCombinedAudit
           ([Guid],UserId,Identifier,IndigoClientId,IndigoClientGuid,ConcurrencyId,StampAction,StampDateTime,StampUser)
SELECT [Guid],UserId,Identifier,IndigoClientId,IndigoClientGuid,ConcurrencyId,'C',GETDATE(),'999999' 
FROM TUserCombined UC
WHERE UC.UserId = @UserId
	
IF @@ERROR != 0 GOTO exit_on_error  
		

IF @@TRANCOUNT > 0 COMMIT TRAN
SELECT 'Success'

RETURN

exit_on_error:

IF @@TRANCOUNT > 0 ROLLBACK TRAN
SELECT 'FAILED'

END
      



GO
